return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Gedit",
      "Gsplit",
      "Gdiffsplit",
      "Gvdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "Glgrep",
      "GMove",
      "GRename",
      "GDelete",
      "GBrowse",
    },
    dependencies = {
      "tpope/vim-rhubarb",
    },
  },
  {
    "tpope/vim-rails",

    event = "VeryLazy",
  },
  {
    "tpope/vim-projectionist",

    event = "VeryLazy",
  },
}
