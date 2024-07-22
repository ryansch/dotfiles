return {
  {
    "folke/which-key.nvim",

    opts = function(_, opts)
      opts.spec = vim.tbl_extend("force", opts.spec, {
        { "<leader>o", group = "open" },
        { "<leader>r", group = "run" },
        { "<leader>t", group = "terminal" },
      })
    end,
  },
}
