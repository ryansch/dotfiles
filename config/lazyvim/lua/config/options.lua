-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.o.showtabline = 2

-- Name the terminal (kitty tab) after the project: "kairos · nvim"
vim.o.title = true
vim.o.titlestring = "%{fnamemodify(getcwd(), ':t')} · nvim"

vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "standardrb"
