local M = {}

local titan_packer_util = require("titan.packer.util")

local plugin_specs = nil
local plugin_specs_by_name = nil
local skip_plugins = nil
local skip_all_plugins = false

local function use(plugin_spec)
  local spec = {
    spec = plugin_spec,
    line = debug.getinfo(2, 'l').currentline,
  }
  spec.name = titan_packer_util.plugin_name(spec.spec, spec.line)

  plugin_specs[#plugin_specs+1] = spec
  plugin_specs_by_name[spec.name] = spec
end

local function skip(name)
  skip_plugins[#skip_plugins+1] = name
end

local function skip_all()
  skip_all_plugins = true
end

function M.reset()
  plugin_specs = {}
  plugin_specs_by_name = {}
  skip_plugins = {}
  skip_all_plugins = false
end

function M.config()
  M.reset()
  -- skip_all()
  -- use 'wbthomason/packer.nvim' -- Package manager

  -- User plugins and overrides go here
  -- use "~/dev/titan.nvim"
  -- use "~/dev/lunarized"

  -- use "~/dev/workspaces.nvim"
  -- use {
  --   "ryansch/habitats.nvim",
  --   requires = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope-file-browser.nvim",
  --     "natecraddock/sessions.nvim",
  --     "natecraddock/workspaces.nvim",
  --   }
  -- }
  
  return {
    plugin_specs = plugin_specs,
    plugin_specs_by_name = plugin_specs_by_name,
    skip_plugins = skip_plugins,
    skip_all_plugins = skip_all_plugins,
  }
end

return M
