local Util = require("lazyvim.util")

local M = {}

function M.find_command()
  return { "fd", "--type", "f", "--no-ignore-vcs" }
end

function M.find_files()
  Util.telescope("find_files", {
    find_command = M.find_command,
    hidden = true,
  })()
end

return M
