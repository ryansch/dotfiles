local pickers = require("util/pickers")

return {
  {
    "snacks.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts or {}, {
        picker = {
          win = {
            input = {
              keys = {
                ["<c-t>"] = { "edit_tab", mode = { "i", "n" } },
              },
            },
          },
          sources = {
            files = {
              hidden = true,
            },
            grep = {
              hidden = true,
            },
          },
        },
      })
    end,

    keys = {
      { "<leader>ff", pickers.pick("files"), desc = "Find Files (Root Dir)" },
      { "<leader>fg", pickers.pick("live_grep"), desc = "Grep (Root Dir)" },
    },
  },
}
