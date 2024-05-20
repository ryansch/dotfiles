vim.api.nvim_create_autocmd("FileType", {
  pattern = { "terraform-vars" },
  desc = "terraform-vars commentstring",
  command = "setlocal commentstring=#\\ %s",
})

return {}
