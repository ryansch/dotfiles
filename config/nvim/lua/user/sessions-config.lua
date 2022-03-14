local M = {}

local default_opts = {
}

local Path = require("plenary.path")

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

  require("sessions").setup{
    session_filepath = Path:new(vim.fn.stdpath("data"), "sessions.nvim").filename,
  }
end

return M
