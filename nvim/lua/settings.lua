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

local actions = require('telescope.actions')
require('telescope').setup {
  defaults = {
    preview = {
      timeout = 500,
      msg_bg_fillchar = "",
    },
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        width_padding = 0.04,
        height_padding = 0.1,
        preview_width = 0.6,
      },
    },
    file_ignore_patterns = {
      "^.git/",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--no-ignore",
      "--follow",
      "--glob '!.git/*'",
    },
    color_devicons = true,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    dynamic_preview_title = true,
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}

-- Load fzf native extension for telescope
require('telescope').load_extension('fzf')

-- Add leader shortcuts
vim.api.nvim_set_keymap('n', '<leader>b', [[<cmd>lua require('telescope.builtin').buffers()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>t', [[<cmd>lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true, follow = true })<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sh', [[<cmd>lua require('telescope.builtin').help_tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]], { noremap = true, silent = true })


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
