return {
  {
    "williamboman/mason.nvim",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "clangd",
        "pyright",
        "terraform-ls",
        "bash-language-server",
        "elixir-ls",
        "solargraph",
        "typescript-language-server",
        "lua-language-server",
      })
    end,
  },
  {
    "folke/neoconf.nvim",

    dependencies = {
      { "ryansch/neoconf-lspcmd" },
      { "nvim-lua/plenary.nvim" },
    },

    opts = function(_, opts)
      opts.plugins = vim.tbl_extend("force", opts.plugins or {}, {
        lspcmd = {
          enabled = true,
          log_level = "info",
          ls_mappings = {
            standardrb = "standardRuby",
          },
        },
      })
    end,

    config = function(_, opts)
      require("neoconf").setup(opts)
      require("neoconf.plugins").register(require("neoconf-lspcmd"))
    end,
  },
}
