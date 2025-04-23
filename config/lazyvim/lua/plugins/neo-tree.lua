return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = function(_, keys)
      vim.list_extend(keys, {
        { "<leader>od", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
        {
          "<leader>of",
          function()
            require("neo-tree.command").execute({ toggle = false, dir = LazyVim.root() })
          end,
          desc = "Focus Explorer NeoTree (root dir)",
        },
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
