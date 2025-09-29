return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "erb-lint",
        "ruby-lsp",
        "standardrb",
      })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "suketa/nvim-dap-ruby",
      config = function()
        require("dap-ruby").setup()
      end,
    },
    keys = {
      {
        "<leader>rd",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest",
      },
    },
  },
  {
    "maxenglander/neotest-minitest",
    branch = "support-spec-dsl",
  },
  {
    "nvim-neotest/neotest",

    -- See https://github.com/nvim-neotest/neotest/issues/531
    commit = "52fca67",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
      "neotest-minitest",
    },

    opts = function(_, opts)
      local neotest = require("neotest")
      local function attach_or_output(client)
        local M = {}
        function M.open(opts)
          opts = opts or {}
          local pos = neotest.run.get_tree_from_args(opts)
          if pos and client:is_running(pos:data().id) then
            neotest.run.attach()
          else
            neotest.output.open({ enter = true })
          end
        end

        return M
      end

      opts.consumers = vim.tbl_extend("force", opts.consumers or {}, {
        attach_or_output = attach_or_output,
        overseer = require("neotest.consumers.overseer"),
      })

      opts.adapters = vim.tbl_extend("force", opts.adapters or {}, {
        ["neotest-minitest"] = {},
      })
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
          "<leader>rl",
          function()
            require("neotest").run.run_last()
          end,
          desc = "Last Test",
        },
        {
          "<leader>ro",
          function()
            -- require("neotest").output.open({ enter = true, auto_close = true })
            require("neotest").attach_or_output.open()
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
    "olimorris/neotest-rspec",

    -- dev = true,
  },
  {
    "overseer.nvim",

    opts = function(_, opts)
      opts.component_aliases = vim.tbl_extend("force", opts.component_aliases or {}, {
        default_neotest = {
          { "display_duration", detail_level = 2 },
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_dispose",
        },
      })
    end,
  },
}
