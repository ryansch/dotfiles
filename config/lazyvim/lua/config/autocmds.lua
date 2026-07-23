-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Per-window winbar badge naming the linked git worktree a buffer lives in.
-- The main checkout stays badge-free (its `.git` is a directory; a linked
-- worktree's `.git` is a file), so normal editing is unchanged and worktree
-- windows stand out. Complements the <leader>fw / <leader>fW pickers in
-- lua/plugins/worktrees.lua.
--
-- Badging a live worktree buffer also tags it (util/worktree.lua) so that, if
-- its worktree is later removed out from under us, the badge flips to a dimmed
-- "(removed)" pill and the buffer becomes eligible for pruning. See the header
-- in lua/util/worktree.lua for the full rationale.
do
  local WT = require("util/worktree")
  local icon = "" -- nerd-font powerline git branch (U+E0A0)

  ---@class WorktreeBadge
  ---@field name string basename of the worktree
  ---@field stale boolean the worktree root has been removed

  ---@param buf integer
  ---@return WorktreeBadge? badge nil when the buffer isn't in a linked worktree
  local function badge(buf)
    if vim.bo[buf].buftype ~= "" then
      return nil -- skip terminals, help, quickfix, etc.
    end
    -- Orphan check first: a buffer we previously tagged as living in a linked
    -- worktree whose root has since vanished. Done before vim.fs.root, which in
    -- a nested-worktree layout would climb past the dead root to the main
    -- checkout's .git and mask the removal.
    local tagged = vim.b[buf].worktree_root
    if tagged and not WT.is_dir(tagged) then
      return { name = vim.fn.fnamemodify(tagged, ":t"), stale = true }
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
    if tagged ~= wt then
      WT.tag(buf, wt) -- remember it: primes the picker's durable anchor + prune
    end
    return { name = vim.fn.fnamemodify(wt, ":t"), stale = false }
  end

  ---@param win? integer
  local function apply(win)
    win = win or vim.api.nvim_get_current_win()
    local b = badge(vim.api.nvim_win_get_buf(win))
    if not b then
      vim.wo[win].winbar = ""
    else
      local hl = b.stale and "WinBarWorktreeStale" or "WinBarWorktree"
      local label = b.name:gsub("%%", "%%%%") .. (b.stale and " (removed)" or "")
      vim.wo[win].winbar = "%=%#" .. hl .. "# " .. icon .. " " .. label .. " %*"
    end
  end

  local grp = vim.api.nvim_create_augroup("worktree_winbar", { clear = true })

  -- Blend the winbar's empty fill into the code background (Normal.bg) -- it's
  -- left unset by lunarized, so it defaults to black -- and render the worktree
  -- badge as a standalone magenta pill on lunarized's chrome bar (bg_tools =
  -- base02) so it stands proud of the fill.
  local function set_hl()
    local ok, lun = pcall(require, "lunarized")
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
    if ok and lun.palette then
      vim.api.nvim_set_hl(0, "WinBar", { fg = lun.palette.fg_tools.hex, bg = normal_bg })
      vim.api.nvim_set_hl(0, "WinBarNC", { fg = lun.palette.fg_tools.hex, bg = normal_bg })
      vim.api.nvim_set_hl(0, "WinBarWorktree", { fg = lun.colors.magenta.hex, bg = lun.palette.bg_tools.hex, bold = true })
      -- Removed worktree: same pill, dimmed (base01 grey) and italic so an
      -- orphaned buffer reads as "gone" rather than active.
      vim.api.nvim_set_hl(0, "WinBarWorktreeStale", { fg = lun.colors.base01.hex, bg = lun.palette.bg_tools.hex, italic = true })
    else
      -- graceful fallback for other colorschemes
      vim.api.nvim_set_hl(0, "WinBar", { link = "Normal" })
      vim.api.nvim_set_hl(0, "WinBarNC", { link = "Normal" })
      vim.api.nvim_set_hl(0, "WinBarWorktree", { link = "Todo" })
      vim.api.nvim_set_hl(0, "WinBarWorktreeStale", { link = "Comment" })
    end
  end
  set_hl()
  vim.api.nvim_create_autocmd("ColorScheme", { group = grp, callback = set_hl })

  vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
    group = grp,
    callback = function()
      apply()
    end,
  })

  -- Prune buffers orphaned by a removed worktree when attention returns to an
  -- editor window. A long-lived terminal (nested :terminal, ToggleTerm) that
  -- ran `git worktree remove` never fires FocusGained -- Neovim never lost OS
  -- focus -- so BufEnter/WinEnter are the reliable signals; FocusGained is a
  -- bonus for the separate-terminal-app case. prune() only wipes unmodified
  -- buffers whose whole worktree root is gone, so this is safe to run often.
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "FocusGained" }, {
    group = grp,
    callback = function()
      WT.prune()
    end,
  })

  -- Badge any windows already open when this loads (VeryLazy).
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    apply(win)
  end
end
