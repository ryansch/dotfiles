return {
  {
    "stevearc/overseer.nvim",

    event = "VeryLazy",

    opts = {
      strategy = {
        "toggleterm",
        -- load your default shell before starting the task
        use_shell = false,
        -- overwrite the default toggleterm "direction" parameter
        direction = "horizontal",
        -- overwrite the default toggleterm "highlights" parameter
        highlights = nil,
        -- overwrite the default toggleterm "auto_scroll" parameter
        auto_scroll = true,
        -- have the toggleterm window close automatically after the task exits
        close_on_exit = false,
        -- open the toggleterm window when a task starts
        open_on_start = true,
        -- mirrors the toggleterm "hidden" parameter, and keeps the task from
        -- being rendered in the toggleable window
        hidden = false,
        -- command to run when the terminal is created. Combine with `use_shell`
        -- to run a terminal command before starting the task
        on_create = nil,
      },

      -- strategy = {
      --   "terminal",
      -- },

      templates = {
        "builtin",
        "user.devenv",
      },

      log = {
        {
          type = "echo",
          level = vim.log.levels.WARN,
        },
        {
          type = "file",
          filename = "overseer.log",
          level = vim.log.levels.DEBUG,
        },
      },

      task_list = {
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["q"] = "<CMD>close<CR>",
        },
      },
    },

    keys = {
      {
        "<leader>ot",
        "<cmd>OverseerToggle<cr>",
        desc = "OverseerToggle",
      },
      {
        "<leader>or",
        "<cmd>OverseerRun<cr>",
        desc = "OverseerRun",
      },
    },
  },
}
