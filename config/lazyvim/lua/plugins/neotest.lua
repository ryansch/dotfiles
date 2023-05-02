return {
  {
    "nvim-neotest/neotest",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
    },

    opts = function()
      return {
        adapters = {
          require("neotest-rspec")({
            rspec_cmd = function()
              local util = require("util")
              return vim.tbl_flatten({
                "direnv",
                "exec",
                util.workspace_root(),
                "rspec",
              })
            end,
          }),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
      }
    end,

    keys = {
      {
        "<leader>rt",
        function()
          require("neotest").run.run()
        end,
        desc = "Nearest Test",
      },
    },
  },
}
