local filename = require('tabby.filename')
local util = require('tabby.util')

local function tab_label(tabid, active)
  local icon = active and '' or ''
  local number = vim.api.nvim_tabpage_get_number(tabid)

  if active then
    return string.format(' %s %d ', icon, number)
  else
    local name = util.get_tab_name(tabid)
    return string.format(' %s %d: %s ', icon, number, name)
  end
end

local function win_label(winid, top)
  local icon = top and '' or ''
  return string.format(' %s %s ', icon, filename.unique(winid))
end

require('plenary.reload').reload_module('lunarized', true)
local palette = require('lunarized').palette
local colors = require('lunarized').colors

local active_tab_bg = palette.accent.darken(5)
local inactive_tab_bg = colors.base03
local top_win_bg = palette.bg_tools.lighten(6)
local win_bg = palette.bg_tools.lighten(4)

local tabline = {
  hl = { fg = palette.fg_tools, bg = palette.bg_tools },
  layout = 'active_tab_with_wins',
  head = {
    { '  ', hl = { fg = palette.fg_tools, bg = palette.bg_tools } },
    { '', hl = { fg = palette.bg_tools, bg = palette.bg_tools } },
  },
  active_tab = {
    label = function(tabid)
      return {
        tab_label(tabid, true),
        hl = { fg = colors.base03, bg = active_tab_bg }
      }
    end,
    left_sep = { '', hl = { fg = active_tab_bg, bg = palette.bg_tools } },
    right_sep = { '', hl = { fg = active_tab_bg, bg = palette.bg_tools } },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        tab_label(tabid),
        hl = { fg = palette.fg_tools, bg = inactive_tab_bg }
      }
    end,
    left_sep = { '', hl = { fg = inactive_tab_bg, bg = palette.bg_tools } },
    right_sep = { '', hl = { fg = inactive_tab_bg, bg = palette.bg_tools } },
  },
  top_win = {
    label = function(winid)
      return {
        win_label(winid, true),
        hl = { fg = palette.fg_tools, bg = top_win_bg, style = "bold" }
      }
    end,
    left_sep = { '', hl = { fg = top_win_bg, bg = palette.bg_tools } },
    right_sep = { '', hl = { fg = top_win_bg, bg = palette.bg_tools } },
  },
  win = {
    label = function(winid)
      return {
        win_label(winid),
        hl = { fg = palette.fg_tools, bg = win_bg }
      }
    end,
    left_sep = { '', hl = { fg = win_bg, bg = palette.bg_tools } },
    right_sep = { '', hl = { fg = win_bg, bg = palette.bg_tools } },
  },
}

require("tabby").setup{
  -- tabline = require("tabby.presets").active_wins_at_end,
  tabline = tabline,
}
