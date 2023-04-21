return {
  {
    "ryansch/habitats.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "natecraddock/sessions.nvim",
      "natecraddock/workspaces.nvim",
    },
    keys = {
      {
        "<leader>oh",
        function()
          require("telescope").extensions.habitats.habitats()
        end,
        desc = "Habitats",
      },
    },
    config = true,
  },
}
