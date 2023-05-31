return {
  {
    "L3MON4D3/LuaSnip",

    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip").filetype_extend("ruby", { "rails" })
    end,
  },
  {
    "ryansch/scissors",

    dev = true,

    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
