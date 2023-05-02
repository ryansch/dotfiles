local M = {}

local lsputil = require("lspconfig.util")

function M.dir_has_file(dir, name)
  return lsputil.path.exists(lsputil.path.join(dir, name)), lsputil.path.join(dir, name)
end

function M.workspace_root()
  local cwd = vim.loop.cwd()

  if M.dir_has_file(cwd, "compose.yml") or M.dir_has_file(cwd, "docker-compose.yml") then
    return cwd
  end

  local function cb(dir, _)
    return M.dir_has_file(dir, "compose.yml") or M.dir_has_file(dir, "docker-compose.yml")
  end

  local root, _ = lsputil.path.traverse_parents(cwd, cb)
  return root
end

function M.workspace_has_file(name)
  local root = M.workspace_root()
  if not root then
    root = vim.loop.cwd()
  end

  return M.dir_has_file(root, name)
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
