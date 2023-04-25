local Util = require("neoconf.util")
local logger = require("util.logger")

local M = {}

M.ls_mappings = {
  standardrb = "standardRuby",
}

function M.on_schema(schema) end

function M.setup()
  Util.on_config({
    name = "lspcmd",
    on_config = M.on_new_config,
  })
end

function M.on_new_config(config, root_dir, original_config)
  -- logger.debug("on_new_config", config, root_dir, original_config)

  -- logger.debug("config.settings", config.settings)

  local name = config["name"]
  local configName = M.ls_mappings[name] or name
  -- logger.debug("configName", configName)

  local commandPath = vim.tbl_get(config.settings, configName, "commandPath")
  -- logger.debug("commandPath", commandPath)

  if commandPath ~= nil then
    local args = vim.list_slice(config.cmd, 2, #config.cmd)
    config.cmd = vim.list_extend({ commandPath }, args)
    -- logger.debug("config.cmd", config.cmd)
  end
end

function M.on_update(fname)
  logger.debug("on_update", fname)
end

return M
