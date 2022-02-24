-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  _G.packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer-config.lua source <afile> | PackerCompile
  augroup end
]])

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'
  use 'saadparwaiz1/cmp_luasnip'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin

  -- Customizations
  use "rktjmp/lush.nvim"
  use "rktjmp/shipwright.nvim"
  -- use "ryansch/lunarized"
  use "~/dev/lunarized"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use "folke/which-key.nvim"
  use 'mhinz/vim-startify'
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
  }
  use 'tpope/vim-eunuch'
  use 'christoomey/vim-tmux-navigator'
  -- use {
  --   'knubie/vim-kitty-navigator',
  --   run = 'cp ./*.py ~/.config/kitty/'
  -- }
  use {'pwntester/octo.nvim' }
  -- use 'sheerun/vim-polyglot'
  -- use "editorconfig/editorconfig-vim"
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-rvm'
  use 'rafamadriz/friendly-snippets' -- TODO: Set up
  use 'sheerun/vim-polyglot'
  use 'bfredl/nvim-luadev'
  use 'outstand/logger.nvim'
  use 'nvim-lua/lsp-status.nvim'
  use 'mhartington/formatter.nvim'
  use {
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require("notify")
    end,
  }

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
    end
  }

  use "vim-test/vim-test"
  use 'ThePrimeagen/harpoon'
  use 'akinsho/toggleterm.nvim'
  use 'tknightz/telescope-termfinder.nvim'
  -- use 'nyngwang/NeoZoom.lua'
  -- use "nanozuki/tabby.nvim"
  use "~/dev/tabby.nvim"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if _G.packer_bootstrap then
    require('packer').sync()
  end
end)
