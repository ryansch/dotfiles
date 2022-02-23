require("packer-config")

require('global')
require("treesitter").setup()
require("lsp").setup()
require("formatting").setup()

-- nvim-tree
local nvim_tree = require("nvim-tree")
nvim_tree.setup {
  auto_close = true,
}

-- which-key
local wk = require('which-key')
local t_builtin = require('telescope.builtin')
local function find_files()
  t_builtin.find_files({
    hidden = true,
    no_ignore = true,
  })
end
wk.setup {
  window = {
    border = "single"
  }
}
wk.register({
  f = {
    name = "telescope finders",
    b = { t_builtin.buffers, "Lists open buffers" },
    f = { find_files, "Find file" },
    h = { t_builtin.help_tags, "Lists available help tags " },
    t = { t_builtin.tags, "Lists tags in current directory " },
    g = { t_builtin.live_grep, "Search for a string" },
    ['?'] = { t_builtin.oldfiles, "Lists previously open files" },
  },
  l = {
    name = "telescope LSP",
    a = { t_builtin.diagostics, "Lists diagnostics" },
    d = { t_builtin.lsp_definitions, "Goto definition" },
    D = { t_builtin.lsp_type_definitions, "Goto type definition" },
    r = { t_builtin.lsp_references, "Lists LSP references" },
    i = { t_builtin.lsp_implementations, "Goto implementation" },
    s = { t_builtin.lsp_document_symbols, "Lists LSP document symbols" },
    w = { t_builtin.lsp_dynamic_workspace_symbols, "Dynamically Lists LSP for all workspace symbols" },
  },
  d = {
    name = "debugger",
    l = {
      name = "lua",
      l = { "<Plug>(Luadev-RunLine)", "Execute the current line" },
      r = { "<Plug>(Luadev-Run)", "Execute lua code over a movement or text object" },
      w = { "<Plug>(Luadev-RunWord)", "Eval identifier under cursor" },
    },
  },
  r = {
    name = "runners",
    f = { "<cmd>Format<cr>", "Format" },
    t = { "<cmd>TestNearest<cr>", "Run test under cursor"},
    T = { "<cmd>TestFile<cr>", "Run tests for file"},
    l = { "<cmd>TestLast<cr>", "Run last test"},
    v = { "<cmd>TestVisit<cr>", "Open last test file used"},
  },
  o = {
    name = "open",
    d = { function() nvim_tree.toggle(true) end, "Open directory" },
    f = { function() nvim_tree.find_file(true) end, "Focus file in directory" },
  },
  t = {
    name = "terminal",
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm direction=vertical<cr>", "Vertical" },
  },
}, { prefix = "<leader>" })

-- Diagnostic keymaps
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Options from kickstart.nvim

--Set highlight on search
vim.o.hlsearch = true

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- End kickstart.nvim options

--Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme lunarized]]

-- Use visual bell
vim.o.visualbell = true

-- Enable hidden buffers
vim.o.hidden = true

-- Automatically reload files changed outside of vim
vim.o.autoread = true

-- Enable system clipboard
vim.o.clipboard = "unnamedplus"

--Incremental live completion (note: this is now a default on master)
vim.o.inccommand = 'nosplit'

--Decrease update time
vim.o.updatetime = 250
vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.wo.signcolumn = 'yes'

--Indenting/tabs/spaces
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.expandtab = true

--Don't show mode (lualine does it already)
vim.o.showmode = false

-- Configure Beacon
vim.g.beacon_size = 90
vim.g.beacon_minimal_jump = 25
vim.g.beacon_ignore_filetypes = { "fzf" }

-- Setup cursorhold
-- vim.g.cursorhold_updatetime = 100

-- Create window splits easier. The default
-- way is Ctrl-w,v and Ctrl-w,s. I remap
-- this to vv and ss
-- vim.api.nvim_set_keymap('n', 'vv', '<C-w>v', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'ss', '<C-w>s', { noremap = true, silent = true })
vim.keymap.set('n', 'vv', '<C-w>v', { noremap=true, silent=true, nowait=true })
vim.keymap.set('n', 'ss', '<C-w>s', { noremap=true, silent=true, nowait=true })

-- neozoom
-- vim.keymap.set('n', 'vv', function () vim.cmd('NeoVSplit') end, { noremap=true, silent=true, nowait=true })
-- vim.keymap.set('n', 'ss', function () vim.cmd('NeoSplit') end, { noremap=true, silent=true, nowait=true })
-- vim.keymap.set('n', '<C-W>"', function () vim.cmd('NeoSplit') end, { noremap=true, silent=true, nowait=true })
-- vim.keymap.set('n', '<C-W>%', function () vim.cmd('NeoVSplit') end, { noremap=true, silent=true, nowait=true })
--
-- vim.keymap.set('n', '<C-Space>z', "<cmd>NeoZoomToggle<cr>", { noremap=true, silent=true, nowait=true })

-- Clear current search highlight by double tapping //
vim.api.nvim_set_keymap('n', '//', ':nohlsearch<CR>', { silent = true })

--Set statusbar
local lunarized_lualine = require('lunarized.lualine')
local function toggleterm_statusline()
  return 'ToggleTerm #' .. vim.b.toggle_number
end
local custom_toggleterm = {
  sections = {
    lualine_a = {'mode'},
    lualine_b = { toggleterm_statusline },
  },
  inactive_sections = {
    lualine_c = { toggleterm_statusline },
  },
  filetypes = { 'toggleterm' },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = lunarized_lualine,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename', "require'lsp-status'.status()"},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = {
    custom_toggleterm,
    'fugitive',
    'nvim-tree',
    'quickfix',
  },
}

-- tabby
require("tabby-config")

--Enable Comment.nvim
require('Comment').setup()

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

--Map blankline
vim.g.indent_blankline_char = '┊'
vim.g.indent_blankline_filetype_exclude = { 'help', 'packer' }
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- vim-startify
vim.g.startify_change_to_vcs_root = 1

if vim.fn.has('macunix') then
  vim.api.nvim_command('set rtp+=/opt/homebrew/opt/fzf')
end

-- gutentags
vim.g.gutentags_cache_dir = "~/.cache/gutentags"

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

-- harpoon
-- vim.g.harpoon_log_level = "debug"
-- require("harpoon").setup({})
-- require("telescope").load_extension('harpoon')

-- toggleterm
local toggleterm = require("toggleterm")

toggleterm.setup{
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  persist_size = false,
  on_open = function(term)
    term.opened = term.opened or false

    if not term.opened then
      term:send("eval $(desk load)")
    end

    term.opened = true
  end,
}

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

require('telescope').load_extension("termfinder")

-- local function dev_transform(cmd)
--   return string.format("dev run --rm rails %s", cmd)
-- end
--
-- vim.g["test#custom_transformations"] = {
--   dev = function(cmd)
--     return dev_transform(cmd)
--   end,
-- }

vim.g["test#custom_strategies"] = {
  toggleterm = function(cmd)
    toggleterm.exec(cmd)
  end,
}

vim.g["test#strategy"] = "toggleterm"
-- vim.g["test#transformation"] = "dev"
vim.g["test#ruby#use_binstubs"] = 0
vim.g["test#ruby#bundle_exec"] = 0

-- TODO:
-- If terminal is hidden when tests finish: show notification
-- Add movement keys to terminal setup

-- vim: ts=2 sts=2 sw=2 et
