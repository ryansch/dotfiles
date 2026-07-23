-- Shared state + helpers for the worktree pickers (plugins/worktrees.lua) and
-- the worktree winbar / orphaned-buffer pruning (config/autocmds.lua).
--
-- The problem this defends against: a linked worktree can be removed out from
-- under a running Neovim -- a long-lived Claude / ToggleTerm session runs
-- `git worktree remove` while its buffers stay open. Every path anchor those
-- buffers have then points into a directory that no longer exists: the buffer
-- name, its LazyVim root, and (if you used the opt-in `<c-w>` cd action) even
-- the global cwd. `git -C <dead> worktree list` exits 128, its stderr doesn't
-- parse as worktree entries, and the pickers silently list nothing -- so you
-- can't even navigate back to the main checkout without restarting.
--
-- The fix is to never trust a single buffer-derived anchor. `list()` tries an
-- ordered set of candidate dirs (see `anchors()`) and uses the first from which
-- git succeeds. The durable backstop is the *main checkout* path, which is
-- never `git worktree remove`d: we cache it the moment we first see any linked
-- worktree buffer, read cheaply from that worktree's `.git` file -- no
-- subprocess -- so it's primed before any removal happens.

---@class WorktreeItem
---@field dir string
---@field file string
---@field branch? string
---@field text? string

local M = {}

-- Absolute paths of main checkouts seen this session, used as durable picker
-- anchors once every live anchor has disappeared.
---@type table<string, true>
M.main_checkouts = {}

---@param path? string
---@return boolean
function M.is_dir(path)
  if type(path) ~= "string" or path == "" then
    return false
  end
  local st = vim.uv.fs_stat(path)
  return st ~= nil and st.type == "directory"
end

-- Resolve the main checkout that owns a worktree root, or nil.
--   * main checkout itself -> `.git` is a directory -> return `wt`
--   * linked worktree      -> `.git` is a small text file:
--         gitdir: /abs/path/to/main/.git/worktrees/<name>
--     strip `/.git/worktrees/<name>` to recover the main checkout.
-- Cheap: one fs_stat plus (for linked worktrees) one small file read.
---@param wt string worktree root
---@return string? main absolute path of the owning main checkout
function M.main_checkout_of(wt)
  local dotgit = wt .. "/.git"
  local st = vim.uv.fs_stat(dotgit)
  if not st then
    return nil
  end
  if st.type == "directory" then
    return vim.fs.normalize(wt)
  end
  if st.type ~= "file" then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, dotgit, "", 1)
  local gitdir = ok and lines[1] and lines[1]:match("^gitdir:%s*(.+)$")
  if not gitdir then
    return nil
  end
  -- gitdir = <main>/.git/worktrees/<name>  ->  <main>
  return vim.fs.normalize(vim.trim(gitdir)):match("^(.*)/%.git/worktrees/[^/]+$")
end

-- Tag a buffer as living in a (live) linked worktree and prime the durable
-- main-checkout cache from it. Called by the winbar as it badges each worktree
-- buffer, so `prune()` and the picker fallback work even for buffers we never
-- explicitly visited a picker from.
---@param buf integer
---@param wt string worktree root
function M.tag(buf, wt)
  vim.b[buf].worktree_root = wt
  local main = M.main_checkout_of(wt)
  if main then
    M.main_checkouts[main] = true
  end
end

-- Ordered, de-duplicated candidate dirs to run `git worktree list` from. Only
-- dirs that still exist are returned; the caller uses the first that yields a
-- successful listing.
---@return string[]
function M.anchors()
  local seen, out = {}, {}
  local function add(p)
    if type(p) ~= "string" or p == "" then
      return
    end
    p = vim.fs.normalize(p)
    if not seen[p] and M.is_dir(p) then
      seen[p] = true
      out[#out + 1] = p
    end
  end

  add(LazyVim.root.get()) -- 1. current buffer's root (may be dead)
  add(vim.uv.cwd()) -- 2. global cwd (<leader>fw never moves it)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do -- 3. dirs of live buffers
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      if name ~= "" then
        add(vim.fs.dirname(name))
      end
    end
  end
  for main in pairs(M.main_checkouts) do -- 4. durable cached main checkouts
    add(main)
  end
  return out
end

-- Parse `git worktree list --porcelain` from the first working anchor.
-- Remembers the main worktree (always the first entry) as a durable anchor.
-- Warns (rather than silently returning nothing) if no anchor works.
---@param exclude? string normalized worktree dir to omit (e.g. the current one)
---@return WorktreeItem[]
function M.list(exclude)
  for _, anchor in ipairs(M.anchors()) do
    local lines = vim.fn.systemlist({ "git", "-C", anchor, "worktree", "list", "--porcelain" })
    if vim.v.shell_error == 0 then
      local items, cur, first_dir = {}, nil, nil
      local function flush()
        if not cur then
          return
        end
        first_dir = first_dir or cur.dir
        if not (exclude and vim.fs.normalize(cur.dir) == exclude) then
          cur.text = vim.fn.fnamemodify(cur.dir, ":t") .. "  " .. (cur.branch or "")
          items[#items + 1] = cur
        end
        cur = nil
      end
      for _, l in ipairs(lines) do
        if l:match("^worktree ") then
          flush() -- entries are delimited by the next `worktree ` line
          local dir = l:sub(10)
          cur = { dir = dir, file = dir }
        elseif l:match("^branch ") and cur then
          cur.branch = l:gsub("^branch refs/heads/", "")
        elseif l:match("^detached") and cur then
          cur.branch = "(detached)"
        end
      end
      flush() -- last entry
      if first_dir then
        M.main_checkouts[vim.fs.normalize(first_dir)] = true
      end
      return items
    end
  end
  Snacks.notify.warn("No live git worktree found -- :cd into the repo and retry")
  return {}
end

-- Resolve the main checkout for the current context, for scoping things
-- (e.g. `claude agents --cwd`) to the repo rather than a transient linked
-- worktree. Every worktree of a repo therefore shares one anchor. Tries the
-- current buffer's worktree, then cwd, then the durable cache; nil if none.
---@return string? main absolute path of the owning main checkout
function M.current_main_checkout()
  for _, src in ipairs({ vim.api.nvim_get_current_buf(), vim.uv.cwd() }) do
    local wt = vim.fs.root(src, ".git") -- worktree top (dir OR file named .git)
    local main = wt and M.main_checkout_of(wt)
    if main then
      return main
    end
  end
  for main in pairs(M.main_checkouts) do -- durable fallback (see anchors())
    if M.is_dir(main) then
      return main
    end
  end
  return nil
end

local pruning = false

-- Wipe buffers whose linked worktree has been removed. Only touches buffers
-- that are both unmodified *and* whose entire worktree root has vanished --
-- never unsaved buffers, never files merely missing mid-checkout.
---@param opts? { silent?: boolean }
---@return integer wiped number of buffers deleted
function M.prune(opts)
  opts = opts or {}
  if pruning then
    return 0 -- guard against re-entrancy: buf_delete fires BufEnter -> prune
  end
  pruning = true
  local wiped = {} ---@type string[]
  local ok, err = pcall(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local root = vim.api.nvim_buf_is_valid(buf) and vim.b[buf].worktree_root or nil
      if root and not M.is_dir(root) and vim.bo[buf].buftype == "" and not vim.bo[buf].modified then
        local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
        wiped[#wiped + 1] = vim.fn.fnamemodify(root, ":t") .. "/" .. base
        pcall(vim.api.nvim_buf_delete, buf, { force = false })
      end
    end
  end)
  pruning = false
  if not ok then
    error(err)
  end
  if #wiped > 0 and not opts.silent then
    Snacks.notify.info(
      ("Pruned %d buffer%s from removed worktree:\n%s"):format(#wiped, #wiped == 1 and "" or "s", table.concat(wiped, "\n"))
    )
  end
  return #wiped
end

return M
