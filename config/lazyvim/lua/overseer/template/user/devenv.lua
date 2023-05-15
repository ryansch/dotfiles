return {
  name = "dev up",

  builder = function(params)
    return {
      cmd = {
        "direnv",
        "exec",
        vim.env.DEVENV_ROOT,
        "dev",
        "up",
        "-df",
      },
    }
  end,

  components = { "unique", "default" },
}
