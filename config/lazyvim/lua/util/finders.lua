local LazyUtil = require("lazyvim.util")

local M = {}

function M.file_exists(file)
  return vim.loop.fs_stat(file) ~= nil
end

function M.find_command()
  return { "fd", "--type", "f", "--no-ignore-vcs" }
end

function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = LazyUtil.get_root() }, opts or {})

    if builtin == "files" then
      if M.file_exists((opts.cwd or vim.loop.cwd()) .. "/.ignore") then
        builtin = "find_files"
        opts.find_command = M.find_command
        opts.hidden = true
      elseif M.file_exists((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    return LazyUtil.telescope(builtin, opts)()
  end
end

return M
