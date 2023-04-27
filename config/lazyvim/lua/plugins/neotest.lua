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
        desc = "Nearest",
      },
    },
  },

  {
    "stevearc/overseer.nvim",

    opts = {
      strategy = {
        "toggleterm",
        -- load your default shell before starting the task
        use_shell = false,
        -- overwrite the default toggleterm "direction" parameter
        direction = nil,
        -- overwrite the default toggleterm "highlights" parameter
        highlights = nil,
        -- overwrite the default toggleterm "auto_scroll" parameter
        auto_scroll = nil,
        -- have the toggleterm window close automatically after the task exits
        close_on_exit = false,
        -- open the toggleterm window when a task starts
        open_on_start = true,
        -- mirrors the toggleterm "hidden" parameter, and keeps the task from
        -- being rendered in the toggleable window
        hidden = false,
        -- command to run when the terminal is created. Combine with `use_shell`
        -- to run a terminal command before starting the task
        on_create = nil,
      },
    },
  },
}
