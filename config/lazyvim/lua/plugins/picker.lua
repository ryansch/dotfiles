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
        },
      })
    end,

    keys = {
      { "<leader>fg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    },
  },
}
