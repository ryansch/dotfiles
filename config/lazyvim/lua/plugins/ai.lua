return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "MCPHub",
    },
    build = "bundled_build.lua", -- Bundles `mcp-hub` binary along with the neovim plugin
    config = function()
      require("mcphub").setup({
        use_bundled_binary = true, -- Use local `mcp-hub` binary
        extensions = {
          copliotchat = false,
          convert_tools_to_functions = true,
          convert_resources_to_functions = true,
          add_mcp_prefix = false,
        },
      })
    end,
  },

  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   build = "make tiktoken",
  --   opts = {
  --     model = "claude-sonnet-4.5",
  --   },
  -- },

  {
    "nickjvandyke/opencode.nvim",
    dependencies = {
      -- Recommended for `ask()` and `select()`.
      -- Required for `snacks` provider.
      ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
      { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
    },
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      local opencode = Terminal:new({
        cmd = "opencode --port",
        display_name = "opencode",
        hidden = true,
        direction = "vertical",
        id = 10,
      })

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
        provider = {
          toggle = function(self)
            opencode:toggle()
          end,
          start = function(self)
            opencode:open()
          end,
          stop = function(self)
            opencode:shutdown()
          end,
        },
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true

      -- Recommended/example keymaps.
      -- vim.keymap.set({ "n", "x" }, "<C-a>", function()
      --   require("opencode").ask("@this: ", { submit = true })
      -- end, { desc = "Ask opencode…" })
      -- vim.keymap.set({ "n", "x" }, "<C-x>", function()
      --   require("opencode").select()
      -- end, { desc = "Execute opencode action…" })
      -- vim.keymap.set({ "n", "t" }, "<C-.>", function()
      --   require("opencode").toggle()
      -- end, { desc = "Toggle opencode" })

      -- vim.keymap.set({ "n", "x" }, "go", function()
      --   return require("opencode").operator("@this ")
      -- end, { desc = "Add range to opencode", expr = true })
      -- vim.keymap.set("n", "goo", function()
      --   return require("opencode").operator("@this ") .. "_"
      -- end, { desc = "Add line to opencode", expr = true })

      -- vim.keymap.set("n", "<S-C-u>", function()
      --   require("opencode").command("session.half.page.up")
      -- end, { desc = "Scroll opencode up" })
      -- vim.keymap.set("n", "<S-C-d>", function()
      --   require("opencode").command("session.half.page.down")
      -- end, { desc = "Scroll opencode down" })

      -- You may want these if you use the opinionated `<C-a>` and `<C-x>` keymaps above — otherwise consider `<leader>o…` (and remove terminal mode from the `toggle` keymap).
      -- vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
      -- vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "x" } },
      {
        "<leader>aa",
        function()
          require("opencode").ask("@this: ", { submit = true })
        end,
        desc = "Ask opencode…",
        mode = { "n", "x" },
      },
      {
        "<leader>as",
        function()
          require("opencode").stop()
        end,
        desc = "Stop opencode",
        mode = { "n", "x" },
      },
      {
        "<leader>at",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle opencode",
        mode = { "n", "x" },
      },
      {
        "<leader>ax",
        function()
          require("opencode").select()
        end,
        desc = "Execute opencode action…",
        mode = { "n", "x" },
      },
    },
  },

  -- {
  --   -- "CopilotChat.nvim",
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
  --     { "mcphub.nvim" },
  --   },
  --   optional = true,
  --   branch = "tools",
  --   build = "make tiktoken",
  --
  --   cmd = {
  --     "CopilotChat",
  --     "CopilotChatPrompts",
  --     "CopilotChatModels",
  --     "CopilotChatAgents",
  --   },
  --
  --   opts = {
  --     model = "copilot:claude-sonnet-4",
  --   },
  --
  --   keys = {
  --     { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
  --   },
  --
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-chat",
  --       callback = function()
  --         vim.opt_local.relativenumber = false
  --         vim.opt_local.number = false
  --       end,
  --     })
  --
  --     chat.setup(opts)
  --
  --     local mcp = require("mcphub")
  --     mcp.on({ "servers_updated", "tool_list_changed", "resource_list_changed" }, function()
  --       local hub = mcp.get_hub_instance()
  --       if not hub then
  --         return
  --       end
  --
  --       local async = require("plenary.async")
  --       local call_tool = async.wrap(function(server, tool, input, callback)
  --         hub:call_tool(server, tool, input, {
  --           callback = function(res, err)
  --             callback(res, err)
  --           end,
  --         })
  --       end, 4)
  --
  --       local access_resource = async.wrap(function(server, uri, callback)
  --         hub:access_resource(server, uri, {
  --           callback = function(res, err)
  --             callback(res, err)
  --           end,
  --         })
  --       end, 3)
  --
  --       for name, tool in pairs(chat.config.functions) do
  --         if tool.id and tool.id:sub(1, 3) == "mcp" then
  --           chat.config.functions[name] = nil
  --         end
  --       end
  --       local resources = hub:get_resources()
  --       for _, resource in ipairs(resources) do
  --         local name = resource.name:lower():gsub(" ", "_"):gsub(":", "")
  --         chat.config.functions[name] = {
  --           id = "mcp:" .. resource.server_name .. ":" .. name,
  --           uri = resource.uri,
  --           description = type(resource.description) == "string" and resource.description or "",
  --           resolve = function()
  --             local res, err = access_resource(resource.server_name, resource.uri)
  --             if err then
  --               error(err)
  --             end
  --
  --             res = res or {}
  --             local result = res.result or {}
  --             local content = result.contents or {}
  --             local out = {}
  --
  --             for _, message in ipairs(content) do
  --               if message.text then
  --                 table.insert(out, {
  --                   uri = message.uri,
  --                   data = message.text,
  --                   mimetype = message.mimeType,
  --                 })
  --               end
  --             end
  --
  --             return out
  --           end,
  --         }
  --       end
  --
  --       local tools = hub:get_tools()
  --       for _, tool in ipairs(tools) do
  --         chat.config.functions[tool.name] = {
  --           id = "mcp:" .. tool.server_name .. ":" .. tool.name,
  --           group = tool.server_name,
  --           description = tool.description,
  --           schema = tool.inputSchema,
  --           resolve = function(input)
  --             local res, err = call_tool(tool.server_name, tool.name, input)
  --             if err then
  --               error(err)
  --             end
  --
  --             res = res or {}
  --             local result = res.result or {}
  --             local content = result.content or {}
  --             local out = {}
  --
  --             for _, message in ipairs(content) do
  --               if message.type == "text" then
  --                 table.insert(out, {
  --                   data = message.text,
  --                 })
  --               elseif message.type == "resource" and message.resource and message.resource.text then
  --                 table.insert(out, {
  --                   uri = message.resource.uri,
  --                   data = message.resource.text,
  --                   mimetype = message.resource.mimeType,
  --                 })
  --               end
  --             end
  --
  --             return out
  --           end,
  --         }
  --       end
  --     end)
  --   end,
  -- },
  -- {
  --   "blink.cmp",
  --   optional = true,
  --   ---@module 'blink.cmp'
  --   ---@type blink.cmp.Config
  --   opts = {
  --     sources = {
  --       providers = {
  --         path = {
  --           enabled = function()
  --             return vim.bo.filetype ~= "copilot-chat"
  --           end,
  --         },
  --       },
  --     },
  --   },
  -- },
}
