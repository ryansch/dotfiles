-- Use full terminal colors
vim.o.termguicolors = true

-- Use colorscheme
vim.cmd("colorscheme lunarized")

-- Use visual bell
vim.o.visualbell = true

-- Automatically reload files changed outside of vim
vim.o.autoread = true

-- Enable system clipboard
vim.o.clipboard = "unnamedplus"

-- Configure Beacon
vim.g.beacon_size = 90
vim.g.beacon_minimal_jump = 25
vim.g.beacon_ignore_filetypes = { "fzf" }

-- Setup cursorhold
vim.g.cursorhold_updatetime = 100

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'solarized_dark',
    component_separators = {'|', '|'},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {'fugitive'}
}

-- Load fzf native extension for telescope
require('telescope').load_extension('fzf')


-- Create window splits easier. The default
-- way is Ctrl-w,v and Ctrl-w,s. I remap
-- this to vv and ss
vim.api.nvim_set_keymap('n', 'vv', '<C-w>v', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ss', '<C-w>s', { noremap = true, silent = true })

-- Clear current search highlight by double tapping //
vim.api.nvim_set_keymap('n', '//', ':nohlsearch<CR>', { silent = true })


-- vim-test
vim.g.ultest_use_pty = 1

local function dev_transform(cmd)
  return "dev run --rm rails " .. cmd
end

vim.g['test#custom_transformations'] = {dev = dev_transform}
vim.g['test#transformation'] = "dev"
vim.g['test#strategy'] = "tslime"
vim.g['test#preserve_screen'] = 1
vim.g['test#ruby#rspec#executable'] = "rspec"

vim.api.nvim_set_keymap('n', '<leader>r', ':TestNearest<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>R', ':TestFile<CR>', { silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<CR>', { silent = true })

vim.opt.list = true
vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    show_end_of_line = true,
}
