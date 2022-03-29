local M = {}

local config = {
}

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  require("habitats").setup{}

  local wk = require("which-key")
  wk.register({
    o = {
      name = "open",
      h = { require("telescope").extensions.habitats.habitats , "Open habitats" },
    },
  }, { prefix = "<leader>" })
end

return M
