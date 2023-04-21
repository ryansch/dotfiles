-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Remove floating terminal keymaps
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

vim.keymap.set("n", "vv", "<C-w>v", { noremap = true, silent = true, nowait = true })
vim.keymap.set("n", "ss", "<C-w>s", { noremap = true, silent = true, nowait = true })

-- Clear current search highlight by double tapping //
vim.api.nvim_set_keymap("n", "//", ":nohlsearch<CR>", { silent = true })
