local M = {}

local default_opts = {
}

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

  require("user.sessions-config").setup{}
  require("user.workspaces-config").setup{}
end

return M
