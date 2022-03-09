-- Install packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  _G.packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Install titan
install_path = fn.stdpath('data')..'/site/pack/packer/start/titan.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/outstand/titan.nvim', install_path})
end

local M = {}

local titan_packer_util = require("titan.packer.util")

function M.startup(user_packer_config)
  local titan_packer_config = require("titan").packer_config
  local overrides = {}

  require('packer').startup(function(use)
    for _, plugin_data in ipairs(titan_packer_config) do
      local plugin_spec = plugin_data.spec
      local spec_line = plugin_data.line

      -- find name
      local name = titan_packer_util.plugin_name(plugin_spec, spec_line)

      -- do we have a user override?
      if user_packer_config.plugin_specs_by_name[name] ~= nil then
        logger.debug("USER: " .. name)
        use(user_packer_config.plugin_specs_by_name[name].spec)
        overrides[#overrides + 1] = name
      else
        logger.debug("titan: " .. name)
        use(plugin_spec)
      end
    end

    for _, plugin_data in ipairs(user_packer_config.plugin_specs) do
      local plugin_spec = plugin_data.spec
      local name = plugin_data.name

      if not vim.tbl_contains(overrides, name) then
        use(plugin_spec)
      end
    end

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if _G.packer_bootstrap then
      require('packer').sync()
    end
  end)
end

return M
