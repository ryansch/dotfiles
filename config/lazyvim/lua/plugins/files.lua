return {
  -- {
  -- "folke/snacks.nvim",
  -- opts = {
  --   explorer = {
  --     sources = {
  --       files = {
  --         show_hidden = true,
  --         respect_gitignore = false,
  --         respect_ignore = true,
  --       },
  --     },
  --   },
  -- },
  -- keys = {
  --   { "<leader>od", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
  --   {
  --     "<leader>of",
  --     function()
  --       local explorer_pickers = Snacks.picker.get({ source = "explorer" })
  --       for _, v in pairs(explorer_pickers) do
  --         v:focus()
  --       end
  --       if #explorer_pickers == 0 then
  --         Snacks.picker.explorer()
  --       end
  --     end,
  --     desc = "Focus Explorer Snacks (root dir)",
  --   },
  -- },

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

  -- {
  --   "dmtrKovalenko/fff.nvim",
  --   build = function()
  --     -- downloads a prebuilt binary or falls back to cargo build
  --     require("fff.download").download_or_build_binary()
  --   end,
  --   -- for nixos:
  --   -- build = "nix run .#release",
  --   opts = {
  --     debug = {
  --       enabled = true,
  --       show_scores = true,
  --     },
  --   },
  --   lazy = false, -- the plugin lazy-initialises itself
  --   keys = {
  --     {
  --       "ff",
  --       function()
  --         require("fff").find_files()
  --       end,
  --       desc = "FFFind files",
  --     },
  --     -- {
  --     --   "fg",
  --     --   function()
  --     --     require("fff").live_grep()
  --     --   end,
  --     --   desc = "LiFFFe grep",
  --     -- },
  --     {
  --       "fz",
  --       function()
  --         require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } })
  --       end,
  --       desc = "Live fffuzy grep",
  --     },
  --     {
  --       "fc",
  --       function()
  --         require("fff").live_grep({ query = vim.fn.expand("<cword>") })
  --       end,
  --       desc = "Search current word",
  --     },
  --   },
  -- },
}
