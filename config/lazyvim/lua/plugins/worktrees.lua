-- Worktree pickers:
--   <leader>fw  jump into a worktree (open its file picker)
--   <leader>fW  open the current file's counterpart from another worktree in a vsplit
--   <leader>bw  wipe buffers left behind by a removed worktree (also automatic)
--
-- Why <leader>fw works without spending a tab or changing the global cwd:
-- LazyVim's root detection is *per-buffer*, not per-cwd (root_spec =
-- { "lsp", { ".git", "lua" }, "cwd" }, recomputed on BufEnter/LspAttach). Every
-- git worktree has its own `.git` file, so once a buffer from a worktree is
-- open, the root-relative pickers (<leader>ff, <leader>/) and LSP already scope
-- to that worktree on their own. So all this picker does is get you the *first*
-- buffer in a worktree -- it opens the file picker scoped to the worktree via a
-- per-call `cwd`, and never touches the global cwd. Buffers from several
-- worktrees coexist happily (distinct absolute paths), which is how "multiple
-- worktrees open at once" works while tabs stay entirely yours.
--
-- Removal resilience (list of worktrees, winbar badge, orphaned-buffer pruning)
-- lives in lua/util/worktree.lua and lua/config/autocmds.lua -- see the header
-- comment there for why a removed worktree used to require restarting Neovim.

local WT = require("util/worktree")

-- <leader>fw: open the file picker scoped to the chosen worktree.
local function pick()
  Snacks.picker.pick({
    source = "worktrees",
    finder = function()
      return WT.list()
    end,
    format = "text",
    preview = "none", -- items are directories; nothing useful to preview
    -- <cr>: open the file picker scoped to the worktree. No global cd, no tab
    -- spent -- buffer-relative root detection takes over once a file is open.
    ---@param item WorktreeItem?
    confirm = function(picker, item)
      picker:close()
      if item then
        Snacks.picker.files({ cwd = item.dir })
      end
    end,
    -- Named actions referenced by string from `keys` (matches how snacks' own
    -- builtin pickers wire keys, and keeps lua_ls happy).
    actions = {
      ---@param item WorktreeItem?
      worktree_grep = function(picker, item)
        picker:close()
        if item then
          Snacks.picker.grep({ cwd = item.dir })
        end
      end,
      ---@param item WorktreeItem?
      worktree_explorer = function(picker, item)
        picker:close()
        if item then
          Snacks.picker.explorer({ cwd = item.dir })
        end
      end,
      ---@param item WorktreeItem?
      worktree_cd = function(picker, item)
        picker:close()
        if item then
          vim.cmd.cd(vim.fn.fnameescape(item.dir))
        end
      end,
    },
    win = {
      input = {
        keys = {
          ["<c-g>"] = { "worktree_grep", mode = { "n", "i" } }, -- grep the worktree
          ["<c-e>"] = { "worktree_explorer", mode = { "n", "i" } }, -- explorer rooted there
          ["<c-w>"] = { "worktree_cd", mode = { "n", "i" } }, -- opt-in: also move global cwd
        },
      },
    },
  })
end

-- <leader>fW: open the current file's counterpart from another worktree in a
-- vsplit (great for diffing/working the same file across worktrees).
local function pick_counterpart()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    Snacks.notify.warn("No file in the current buffer")
    return
  end
  local cursor = vim.api.nvim_win_get_cursor(0) -- { row, col }, captured before the picker steals focus
  local cur_wt = vim.fs.root(0, ".git")
  if not cur_wt then
    Snacks.notify.warn("Current buffer isn't inside a git worktree")
    return
  end
  cur_wt = vim.fs.normalize(cur_wt)
  -- path of the file *relative to its worktree root* -- the counterpart's path
  -- in any other worktree.
  local rel = vim.fs.normalize(path):sub(#cur_wt + 2)
  Snacks.picker.pick({
    source = "worktrees",
    finder = function()
      return WT.list(cur_wt) -- exclude the worktree we're already in
    end,
    format = "text",
    preview = "none",
    ---@param item WorktreeItem?
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      local target = vim.fs.normalize(item.dir .. "/" .. rel)
      if not vim.uv.fs_stat(target) then
        Snacks.notify.warn(rel .. " doesn't exist in " .. vim.fn.fnamemodify(item.dir, ":t"))
        return
      end
      vim.cmd("vsplit " .. vim.fn.fnameescape(target))
      -- jump to the same line/column, clamped to the counterpart's contents
      local row = math.min(cursor[1], vim.api.nvim_buf_line_count(0))
      local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1] or ""
      vim.api.nvim_win_set_cursor(0, { row, math.min(cursor[2], #line) })
    end,
  })
end

return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>fw", pick, desc = "Worktrees" },
    { "<leader>fW", pick_counterpart, desc = "Worktree file → vsplit" },
    {
      "<leader>bw",
      function()
        if WT.prune() == 0 then
          Snacks.notify.info("No removed-worktree buffers to prune")
        end
      end,
      desc = "Wipe removed-worktree buffers",
    },
  },
}
