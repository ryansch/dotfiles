return {
  {
    "fzf-lua",
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      config.defaults.actions.files["ctrl-t"] = actions.file_tabedit
    end,

    keys = {
      { "<leader>fg", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
    },
  },
}
