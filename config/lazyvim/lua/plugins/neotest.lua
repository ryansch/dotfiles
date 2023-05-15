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
                ".bin/rspec",
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
      {
        "<leader>ra",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test Current File",
      },
      {
        "<leader>ra",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Test Current File",
      },
      {
        "<leader>rs",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary",
      },
    },
  },
}
