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
        "ruby-lsp",
        "typescript-language-server",
        "lua-language-server",
      })
    end,
  },
}
