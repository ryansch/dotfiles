local Util = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = function(_, keys)
      vim.list_extend(keys, {
        { "<leader>fg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
      })
    end,
  },
}
