return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local icons = require("lazyvim.config").icons
      local Util = require("lazyvim.util")

      --Set statusbar
      local lunarized_lualine = require("lunarized.lualine")
      local function toggleterm_statusline()
        return "ToggleTerm #" .. vim.b.toggle_number
      end
      local custom_toggleterm = {
        sections = {
          lualine_a = { "mode" },
          lualine_b = { toggleterm_statusline },
        },
        inactive_sections = {
          lualine_c = { toggleterm_statusline },
        },
        filetypes = { "toggleterm" },
      }

      opts.options = vim.tbl_extend("force", opts.options, {
        icons_enabled = true,
        theme = lunarized_lualine,
        component_separators = "|",
        section_separators = "",
      })

      opts.sections = vim.tbl_extend("force", opts.sections, {
        -- lualine_c = {
        --   {
        --     "diagnostics",
        --     symbols = {
        --       error = icons.diagnostics.Error,
        --       warn = icons.diagnostics.Warn,
        --       info = icons.diagnostics.Info,
        --       hint = icons.diagnostics.Hint,
        --     },
        --   },
        --   { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
        --   { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
        --   -- stylua: ignore
        --   {
        --     function() return require("nvim-navic").get_location() end,
        --     cond = function() return package.loaded["nvim-navic"] and require("nvim-navic").is_available() end,
        --   },
        -- },
        lualine_x = { { "filetype", icons_enabled = true } },
        lualine_y = {
          -- stylua: ignore
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = Util.fg("Statement"),
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = Util.fg("Constant"),
          },
          -- stylua: ignore
          {
            function() return "  " .. require("dap").status() end,
            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
            color = Util.fg("Debug"),
          },
          { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = Util.fg("Special") },
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
          },
        },
        lualine_z = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
      })

      -- opts.sections = {
      --   lualine_a = { "mode" },
      --   lualine_b = { "branch", "diff", "diagnostics" },
      --   lualine_c = { "filename", "require'lsp-status'.status()" },
      --   lualine_x = { "encoding", "fileformat", "filetype" },
      --   lualine_y = { "progress" },
      --   lualine_z = { "location" },
      -- }

      opts.extensions = {
        custom_toggleterm,
        "quickfix",
      }
    end,
  },
}
