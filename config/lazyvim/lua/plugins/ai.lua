return {
  {
    "CopilotChat.nvim",
    optional = true,
    build = "make tiktoken",
    opts = {
      model = "copilot:claude-sonnet-4",
    },
    keys = {
      { "<leader>am", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
    },
  },
  {
    "blink.cmp",
    optional = true,
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        providers = {
          path = {
            enabled = function()
              return vim.bo.filetype ~= "copilot-chat"
            end,
          },
        },
      },
    },
  },
}
