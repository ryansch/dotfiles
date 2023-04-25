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

    config = function(plugin, opts)
      require("neoconf").setup(opts)

      require("neoconf.plugins").register(require("util.lspcmd"))
    end,
  },
}
