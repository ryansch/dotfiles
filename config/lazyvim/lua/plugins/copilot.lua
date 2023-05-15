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

  {
    "copilot-cmp",

    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      require("lazyvim.util").on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)
    end,
  },
}
