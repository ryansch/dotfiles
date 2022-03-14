local M = {}

local default_opts = {
}

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

  require("user.sessions").setup{}
  require("user.workspaces").setup{}
end

return M
