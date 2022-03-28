local M = {}

local default_opts = {
}

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

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
