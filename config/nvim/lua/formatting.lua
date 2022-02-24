local M = {}

local formatter = require("formatter")

function M.setup()
  formatter.setup({
    logging = true,
    log_level = 0,
    filetype = {
      -- ruby = {
      --   -- rubocop
      --   function()
      --     return {
      --       exe = "/home/ubuntu/dev/app/.bin/rubocop",
      --       args = { '--auto-correct', '--stdin', '%:p', '2>/dev/null', '|', "awk 'f; /^====================$/{f=1}'"},
      --       stdin = true,
      --     }
      --   end
      -- },
    }
  })

--   vim.api.nvim_exec([[
--   augroup FormatAutogroup
--     autocmd!
--     autocmd BufWritePost *.rb FormatWrite
--   augroup END
-- ]], true)
end

return M
