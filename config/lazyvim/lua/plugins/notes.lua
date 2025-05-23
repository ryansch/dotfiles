-- local zk_home = vim.fn.expand("~/.zettelkasten")
--
-- return {
--   {
--     "renerocksai/telekasten.nvim",
--     dependencies = {
--       "nvim-telescope/telescope.nvim",
--       "renerocksai/calendar-vim",
--       "nvim-telescope/telescope-symbols.nvim",
--     },
--
--     opts = {
--       home = zk_home,
--       template_new_daily = zk_home .. "/templates/daily.md",
--     },
--   },
--   {
--     "toppair/peek.nvim",
--     event = { "VeryLazy" },
--     build = "deno task --quiet build:fast",
--     config = function()
--       require("peek").setup()
--       -- refer to `configuration to change defaults`
--       vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
--       vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
--     end,
--   },
-- }

return {
  {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
    config = true,
  },
}
