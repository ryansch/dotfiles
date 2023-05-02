return {
  name = "devenv up",

  builder = function(params)
    return {
      cmd = {
        "direnv",
        "exec",
        vim.env.DEVENV_ROOT,
        "devenv",
        "up",
      },
    }
  end,

  components = { "unique", "default" },
}
