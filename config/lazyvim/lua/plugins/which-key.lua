return {
  {
    "folke/which-key.nvim",

    opts = function(_, opts)
      opts.defaults = vim.tbl_extend("force", opts.defaults, {
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>o"] = { name = "+open" },
        ["<leader>r"] = { name = "+run" },
      })
    end,
  },
}
