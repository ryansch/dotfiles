-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Per-window winbar badge naming the linked git worktree a buffer lives in.
-- The main checkout stays badge-free (its `.git` is a directory; a linked
-- worktree's `.git` is a file), so normal editing is unchanged and worktree
-- windows stand out. Complements the <leader>fw / <leader>fW pickers in
-- lua/plugins/worktrees.lua.
do
  local icon = "" -- nerd-font powerline git branch (U+E0A0)

  ---@param buf integer
  ---@return string? name basename of the linked worktree, or nil
  local function badge(buf)
    if vim.bo[buf].buftype ~= "" then
      return nil -- skip terminals, help, quickfix, etc.
    end
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then
      return nil
    end
    local wt = vim.fs.root(name, ".git")
    if not wt then
      return nil
    end
    local st = vim.uv.fs_stat(wt .. "/.git")
    if not st or st.type ~= "file" then
      return nil -- linked worktrees only (.git is a file, not a dir)
    end
    return vim.fn.fnamemodify(wt, ":t")
  end

  ---@param win? integer
  local function apply(win)
    win = win or vim.api.nvim_get_current_win()
    local b = badge(vim.api.nvim_win_get_buf(win))
    vim.wo[win].winbar = b and ("%=%#WinBarWorktree# " .. icon .. " " .. b:gsub("%%", "%%%%") .. " %*") or ""
  end

  local grp = vim.api.nvim_create_augroup("worktree_winbar", { clear = true })

  local function set_hl()
    vim.api.nvim_set_hl(0, "WinBarWorktree", { link = "Special", default = true })
  end
  set_hl()
  vim.api.nvim_create_autocmd("ColorScheme", { group = grp, callback = set_hl })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    group = grp,
    callback = function()
      apply()
    end,
  })

  -- Badge any windows already open when this loads (VeryLazy).
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    apply(win)
  end
end
