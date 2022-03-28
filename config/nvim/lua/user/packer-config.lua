local M = {}

local titan_packer_util = require("titan.packer.util")

local plugin_specs = nil
local plugin_specs_by_name = nil

local function use(plugin_spec)
  local spec = {
    spec = plugin_spec,
    line = debug.getinfo(2, 'l').currentline,
  }
  spec.name = titan_packer_util.plugin_name(spec.spec, spec.line)

  plugin_specs[#plugin_specs + 1] = spec
  plugin_specs_by_name[spec.name] = spec
end

function M.reset()
  plugin_specs = {}
  plugin_specs_by_name = {}
end

function M.config()
  M.reset()

  -- User plugins and overrides go here
  use "~/dev/titan.nvim"
  use "~/dev/lunarized"

  use "nvim-telescope/telescope-file-browser.nvim"
  use {
    "~/dev/habitats.nvim",
    requires = {
      "natecraddock/sessions.nvim",
      "natecraddock/workspaces.nvim"
    }
  }

  return {
    plugin_specs = plugin_specs,
    plugin_specs_by_name = plugin_specs_by_name,
  }
end

return M
