local M = {}

local default_opts = {
}

local Path = require("plenary.path")

function M.setup(conf)
  conf = vim.tbl_deep_extend('force', default_opts, conf or {})

  require("workspaces").setup{
    path = Path:new(vim.fn.stdpath("data"), "workspaces.nvim").filename,
    global_cd = true,
    sort = true,
    notify_info = true,
    hooks = {
      add = {},
      remove = {},
      open_pre = {
        function()
          logger.debug("workspaces.open_pre")
          require("user.sessions").save_and_stop()

          for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
            -- TODO: Deal with terminal windows
            -- TODO: Deal with modified buffers
            vim.cmd(string.format("bwipeout %d", bufnr))
          end
        end,
      },
      open = {
        function(name)
          logger.debug("workspaces.open")
          vim.cmd("Startify")

          require("titan.lsp").reload_custom_commands()
          require("user.sessions").load(name)

          -- Set kitty tab name
          -- local result = vim.fn.system({"kitty", "@", "set-tab-title", "-m", "recent:0", name})
          -- print(result)
        end,
      },
    },
  }

  require("telescope").load_extension("workspaces")
end

return M
