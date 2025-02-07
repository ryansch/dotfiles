local Util = require("util")

local M = {}

function M.pick(command, opts)
  return function()
    opts = vim.tbl_deep_extend("force", { cwd = LazyVim.root.get() }, opts or {})
    if Util.file_exists_in_dir(opts.cwd, ".ignore") then
      opts.args = { "--no-ignore-vcs" }
    end
    LazyVim.pick.open(command, vim.deepcopy(opts))
  end
end

return M
