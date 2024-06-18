local LazyVim = require("lazyvim.util")
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

function M.find_command()
  return { "fd", "--type", "f", "--no-ignore-vcs" }
end

function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = LazyVim.root.get() }, opts or {})

    if builtin == "files" then
      if M.file_exists_in_dir(opts.cwd, ".ignore") then
        builtin = "find_files"
        opts.find_command = M.find_command
        opts.hidden = true
      elseif M.file_exists_in_dir(opts.cwd, ".git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    return LazyVim.pick.open(builtin, opts)
  end
end

return M
