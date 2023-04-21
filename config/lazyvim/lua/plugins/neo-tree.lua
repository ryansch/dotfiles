return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function(_, keys)
      vim.list_extend(keys, {
        { "<leader>od", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
      })
    end,
    opts = function(_, opts)
      opts.window.mappings = vim.tbl_extend("error", opts.window.mappings, {
        ["<C-v>"] = "open_vsplit",
        ["<C-t>"] = "open_tabnew",
      })
    end,
  },
}
