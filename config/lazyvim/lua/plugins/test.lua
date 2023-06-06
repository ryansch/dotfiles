return {
  {
    "nvim-neotest/neotest",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
    },

    opts = function(_, opts)
      opts.adapters = vim.tbl_extend("force", opts.adapters or {}, {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            local finders = require("util.finders")
            if finders.file_exists(".bin/rspec") then
              return vim.tbl_flatten({
                ".bin/rspec",
              })
            else
              return vim.tbl_flatten({
                "rspec",
              })
            end
          end,
        },
      })

      -- opts.consumers = vim.tbl_extend("force", opts.consumers or {}, {
      --   overseer = require("neotest.consumers.overseer"),
      -- })
    end,

    keys = function()
      return {
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
          "<leader>ro",
          function()
            require("neotest").output.open({ enter = true, auto_close = true })
          end,
          desc = "Show Output",
        },
        {
          "<leader>rO",
          function()
            require("neotest").output_panel.toggle()
          end,
          desc = "Toggle Output Panel",
        },
        {
          "<leader>rs",
          function()
            require("neotest").summary.toggle()
          end,
          desc = "Toggle Test Summary",
        },
        {
          "<leader>rS",
          function()
            require("neotest").run.stop()
          end,
          desc = "Stop",
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    keys = function()
      return {
        {
          "<leader>rd",
          function()
            require("neotest").run.run({ strategy = "dap" })
          end,
          desc = "Debug Nearest",
        },
      }
    end,
  },
}
