local M = {}
local Path = require("plenary.path")
local sessions = require("sessions")

local config = {
  session_path = Path:new(vim.fn.stdpath("data"), "sessions.nvim"),
}

function M.load(name)
  local path = config.session_path:joinpath(name).filename

  sessions.load(path, { silent = true })
  sessions.save(path)
end

function M.save_and_stop()
  sessions.stop_autosave()
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require("sessions").setup{}
end

return M
