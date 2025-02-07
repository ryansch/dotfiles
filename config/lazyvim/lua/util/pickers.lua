local Path = require("plenary.path")

local M = {}

function M.file_exists(...)
  return Path:new(...):exists()
end

function M.file_exists_in_dir(dir, ...)
  return M.file_exists(Path:new(dir, ...))
end

function M.file_exists_in_cwd(...)
  return M.file_exists_in_dir(LazyVim.root.cwd(), ...)
end

function M.file_exists_in_root(...)
  return M.file_exists_in_dir(LazyVim.root.get(), ...)
end

function M.pick(command, opts)
  opts = opts or {}
  return function()
    opts = vim.tbl_deep_extend("force", { cwd = LazyVim.root.get() }, opts or {})
    if M.file_exists_in_dir(opts.cwd, ".ignore") then
      opts.args = { "--no-ignore-vcs" }
    end
    LazyVim.pick.open(command, vim.deepcopy(opts))
  end
end

return M
