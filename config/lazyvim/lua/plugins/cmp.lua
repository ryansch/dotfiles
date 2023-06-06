return {
  {
    "hrsh7th/nvim-cmp",

    opts = function(_, opts)
      local cmp = require("cmp")

      opts.window = vim.tbl_extend("force", opts.window or {}, {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      })
    end,
  },
}
