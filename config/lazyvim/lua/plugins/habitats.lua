return {
  {
    "ryansch/habitats.nvim",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "natecraddock/sessions.nvim",
      "natecraddock/workspaces.nvim",
    },

    event = "VeryLazy",

    keys = {
      {
        "<leader>oh",
        function()
          require("telescope").extensions.habitats.habitats()
        end,
        desc = "Habitats",
      },
    },

    -- opts = {
    --   log_level = "debug",
    -- },

    config = function(_, opts)
      require("habitats").setup(opts)
      require("telescope").load_extension("habitats")
    end,
  },

  {
    "goolord/alpha-nvim",
    opts = function(_, dashboard)
      local button = dashboard.button("h", " " .. " Habitats", ":Telescope habitats <CR>")
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
      table.insert(dashboard.section.buttons.val, 4, button)
    end,
  },
}
