local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  --
  -- (profiling/speed improvements) --
  use 'dstein64/vim-startuptime'
  use 'lewis6991/impatient.nvim'
  use 'nathom/filetype.nvim'

  --
  -- (appearance/ui) --
  use "rktjmp/lush.nvim"
  use "ryansch/lunarized"
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }
  use "norcalli/nvim-colorizer.lua"
  use "kyazdani42/nvim-web-devicons"
  use "danilamihailov/beacon.nvim"
  use "antoinemadec/FixCursorHold.nvim" -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
  use "karb94/neoscroll.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "MunifTanjim/nui.nvim"
  use "folke/which-key.nvim"
  -- use {
  --   'goolord/alpha-nvim',
  --   requires = { 'kyazdani42/nvim-web-devicons' },
  --   config = function ()
  --     require'alpha'.setup(require'alpha.themes.startify'.opts)
  --   end
  -- }
  use 'mhinz/vim-startify'
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- --
  -- -- (lsp/completion) --
  use "neovim/nvim-lspconfig"
  -- -- use "williamboman/nvim-lsp-installer"
  use "nvim-lua/plenary.nvim"
  use "nvim-lua/popup.nvim"
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "saadparwaiz1/cmp_luasnip"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-emoji"
  use "f3fora/cmp-spell"
  use "hrsh7th/cmp-cmdline"
  use "hrsh7th/cmp-nvim-lsp-document-symbol"

  -- for fuzzy things in nvim-cmp and command:
  -- "tzachar/fuzzy.nvim",
  -- { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  -- "tzachar/cmp-fuzzy-path",
  -- "tzachar/cmp-fuzzy-buffer",
  --

  use "L3MON4D3/LuaSnip"
  -- use "rafamadriz/friendly-snippets"
  -- use "nvim-lua/lsp-status.nvim"
  -- use "nvim-lua/lsp_extensions.nvim"
  -- use "ray-x/lsp_signature.nvim"
  -- use "jose-elias-alvarez/nvim-lsp-ts-utils"
  -- use "jose-elias-alvarez/null-ls.nvim"
  -- use "b0o/schemastore.nvim"
  -- use "folke/trouble.nvim"
  -- use "abecodes/tabout.nvim"
  -- { url = "https://gitlab.com/yorickpeterse/nvim-dd.git" },
 
  -- --
  -- -- (treesitter) --
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      vim.cmd("TSUpdate")
    end
  }
  -- use "nvim-treesitter/nvim-treesitter-textobjects"
  -- use "nvim-treesitter/playground"
  -- use "RRethy/nvim-treesitter-textsubjects"
  -- use "mfussenegger/nvim-ts-hint-textobject"
  -- use "JoosepAlviste/nvim-ts-context-commentstring"
  -- use "windwp/nvim-ts-autotag"
  -- use "p00f/nvim-ts-rainbow"
  
   -- (file/document navigation) --
   -- use { 'ibhagwan/fzf-lua',
   --   requires = {
   --     'vijaymarupudi/nvim-fzf',
   --   'kyazdani42/nvim-web-devicons' } -- optional for icons
   -- }
   use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
   use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
   use "voldikss/vim-floaterm"
  
   --
   -- (git, vcs, et al) --
   use "mattn/webapi-vim"
   use "rhysd/conflict-marker.vim"
   use "itchyny/vim-gitbranch"
   use "rhysd/git-messenger.vim"
   use "sindrets/diffview.nvim"
   use 'tpope/vim-fugitive'
   use 'tpope/vim-git'
   use 'tpope/vim-rhubarb'
   use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
   use {'pwntester/octo.nvim' }
  
   --
   -- (development, et al) --
   use { 'preservim/nerdtree',
     requires = {
      'Xuyuanp/nerdtree-git-plugin'
     }
   }
   use 'sheerun/vim-polyglot'
   use 'jtratner/vim-flavored-markdown'
   -- use { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end }
   use 'skwp/vim-html-escape'
   use 'mxw/vim-jsx'
   use "editorconfig/editorconfig-vim"
   -- use "sunaku/tmux-navigate"
   use 'christoomey/vim-tmux-navigator'
  
   use 'tpope/vim-abolish'
   use 'tpope/vim-endwise'
   use 'tpope/vim-ragtag'
   use 'tpope/vim-repeat'
   use 'tpope/vim-surround'
   use 'tpope/vim-unimpaired'
  
   use 'tomtom/tcomment_vim'
   -- use 'ludovicchabant/vim-gutentags' -- Automatic tags management
  
   -- "ahmedkhalf/project.nvim",
   use "tpope/vim-projectionist"
   use { "rcarriga/vim-ultest", requires = {"vim-test/vim-test"}, run = ":UpdateRemotePlugins" }
   -- "tpope/vim-ragtag",
   -- "rizzatti/dash.vim",
   -- { "zenbro/mirror.vim", opt = true },
   -- "vuki656/package-info.nvim",
   -- "jamestthompson3/nvim-remote-containers",
   -- -- { "chipsenkbeil/distant.nvim", branch = "MigrateToRustLib" },
   -- "chipsenkbeil/distant.nvim",
  
   --
   -- (ruby) --
   use 'tpope/vim-rails'
   use 'tpope/vim-rake'
   use 'tpope/vim-rvm'
   use 'vim-ruby/vim-ruby'
   use 'keith/rspec.vim'
   use 'skwp/vim-iterm-rspec'
   use 'skwp/vim-spec-finder'
   use 'ck3g/vim-change-hash-syntax'
   use 'tpope/vim-bundler'
  
  
   --
   -- (more??) --
   use 'tpope/vim-eunuch'
   use 'ekalinin/Dockerfile.vim'
   use 'wesQ3/vim-windowswap'
   use 'itspriddle/vim-marked'
   use 'markcornick/vim-terraform'
   use 'junegunn/goyo.vim'
   use 'tpope/vim-obsession'
   use 'junegunn/gv.vim'
   use 'markcornick/vim-bats'
   use 'zimbatm/haproxy.vim'
   use 'janko-m/vim-test'
   use 'tpope/vim-dispatch'
   use { 'jgdavey/tslime.vim', branch = 'main' }
   use 'stevearc/vim-arduino'
   use { 'earthly/earthly.vim', branch = 'main' }

end)
