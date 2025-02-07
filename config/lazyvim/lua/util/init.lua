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

function M.workspace_has_file(name)
  return M.file_exists_in_root(name)
end

M.logger = require("plenary.log").new({
  plugin = "lazyvim",
  level = "debug",
})

-- Example Usage:
--
-- local s = util.switch {
--   ["tsserver"] = function()
--     logger.debug("Adding", server_name, "to lspconfig via typescript")
--     require("typescript").setup({
--       server = opts
--     })
--   end,
--   default = function()
--     logger.debug("Adding", server_name, "to lspconfig")
--     lspconfig[server_name].setup(opts)
--   end
-- }
--
-- s:case(server_name)
--
function M.switch(t)
  t.case = function(self, x)
    local f = self[x] or self.default
    if f then
      if type(f) == "function" then
        f(x, self)
      else
        error("case " .. tostring(x) .. " not a function")
      end
    end
  end
  return t
end

return M
