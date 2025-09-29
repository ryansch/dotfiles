return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>od", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    {
      "<leader>of",
      function()
        local explorer_pickers = Snacks.picker.get({ source = "explorer" })
        for _, v in pairs(explorer_pickers) do
          v:focus()
        end
        if #explorer_pickers == 0 then
          Snacks.picker.explorer()
        end
      end,
      desc = "Focus Explorer Snacks (root dir)",
    },
  },
}
