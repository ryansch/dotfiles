-- Additional ruby-lsp config
-- textDocument/diagnostic support until 0.10.0 is released
_timers = {}

local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then
        diagnostic_items = result.items
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ruby",
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "erb-lint",
        "ruby-lsp",
        "standardrb",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_ls = {
          on_attach = function(client, buffer)
            setup_diagnostics(client, buffer)
          end,
        },
      },
    },
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
    "nvim-neotest/neotest",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "olimorris/neotest-rspec",
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
    "folke/neodev.nvim",
    opts = {
      library = { plugins = { "neotest" }, types = true },
    },
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
