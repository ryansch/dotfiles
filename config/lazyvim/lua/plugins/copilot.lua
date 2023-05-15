return {
  {
    "copilot.lua",

    opts = function(_, opts)
      opts.filetypes = vim.tbl_extend("force", opts.filetypes or {}, {
        filetypes = {
          TelescopePrompt = false,
        },
      })
    end,
  },
}
