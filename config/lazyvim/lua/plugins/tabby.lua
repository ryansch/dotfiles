return {
  {
    "nanozuki/tabby.nvim",

    event = "VeryLazy",

    opts = function(_, opts)
      local config = {
        layout = "active_wins_at_tail",
      }

      local filename = require("tabby.filename")
      local util = require("tabby.util")

      local function get_win_name(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local ft = vim.api.nvim_buf_get_option(bufid, "filetype")
        if ft == "toggleterm" then
          return "ToggleTerm #" .. vim.api.nvim_buf_get_var(bufid, "toggle_number")
        else
          return filename.unique(winid)
        end
      end

      local function tab_label(tabid, active)
        local icon = active and "" or ""
        local number = vim.api.nvim_tabpage_get_number(tabid)

        if active then
          return string.format(" %s %d ", icon, number)
        else
          local name = util.get_tab_name(tabid)
          return string.format(" %s %d: %s ", icon, number, name)
        end
      end

      local function win_label(winid, top)
        local icon = top and "" or ""
        return string.format(" %s %s ", icon, get_win_name(winid))
      end

      local palette = require("lunarized").palette
      local colors = require("lunarized").colors

      local fg_tools = palette.fg_tools.hex
      local bg_tools = palette.bg_tools.hex
      local active_tab_bg = palette.accent.darken(5).hex
      local inactive_tab_bg = colors.base03.hex
      local top_win_bg = palette.bg_tools.lighten(6).hex
      local win_bg = palette.bg_tools.lighten(4).hex

      local tabline = {
        hl = { fg = fg_tools, bg = bg_tools },
        layout = config.layout,
        head = {
          { "  ", hl = { fg = fg_tools, bg = bg_tools } },
          { "", hl = { fg = bg_tools, bg = bg_tools } },
        },
        active_tab = {
          label = function(tabid)
            return {
              tab_label(tabid, true),
              hl = { fg = colors.base03.hex, bg = active_tab_bg },
            }
          end,
          left_sep = { "", hl = { fg = active_tab_bg, bg = bg_tools } },
          right_sep = { "", hl = { fg = active_tab_bg, bg = bg_tools } },
        },
        inactive_tab = {
          label = function(tabid)
            return {
              tab_label(tabid),
              hl = { fg = fg_tools, bg = inactive_tab_bg },
            }
          end,
          left_sep = { "", hl = { fg = inactive_tab_bg, bg = bg_tools } },
          right_sep = { "", hl = { fg = inactive_tab_bg, bg = bg_tools } },
        },
        top_win = {
          label = function(winid)
            return {
              win_label(winid, true),
              hl = { fg = fg_tools, bg = top_win_bg, style = "bold" },
            }
          end,
          left_sep = { "", hl = { fg = top_win_bg, bg = bg_tools } },
          right_sep = { "", hl = { fg = top_win_bg, bg = bg_tools } },
        },
        win = {
          label = function(winid)
            return {
              win_label(winid),
              hl = { fg = fg_tools, bg = win_bg },
            }
          end,
          left_sep = { "", hl = { fg = win_bg, bg = bg_tools } },
          right_sep = { "", hl = { fg = win_bg, bg = bg_tools } },
        },
        tail = {
          { "", hl = { fg = bg_tools, bg = bg_tools } },
          { "  ", hl = { fg = fg_tools, bg = bg_tools } },
        },
      }

      opts.tabline = tabline
    end,
  },
}
