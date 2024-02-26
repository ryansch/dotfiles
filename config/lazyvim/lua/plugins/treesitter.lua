return {
  {
    "nvim-treesitter/nvim-treesitter",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "arduino",
        "bash",
        "comment",
        "css",
        "devicetree",
        "diff",
        "dockerfile",
        "eex",
        "elixir",
        "erlang",
        "git_config",
        "git_rebase",
        "gitattributes",
        "gitcommit",
        "gitignore",
        "go",
        "graphql",
        "heex",
        "hjson",
        "html",
        "http",
        "javascript",
        "jq",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_inline",
        "ninja",
        "nix",
        "passwd",
        "python",
        "regex",
        "ruby",
        "rust",
        "scss",
        "sql",
        "swift",
        "teal",
        "terraform",
        "todotxt",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
        "zig",
      })

      opts.context_commentstring = vim.tbl_extend("force", opts.context_commentstring or {}, {
        enable = true,
        config = {
          terraform = {
            __default = "# %s",
          },
          nix = {
            __default = "# %s",
          },
        },
      })

      opts.auto_install = true
    end,

    ---@param opts TSConfig
    -- config = function(_, opts)
    --   if type(opts.ensure_installed) == "table" then
    --     ---@type table<string, boolean>
    --     local added = {}
    --     opts.ensure_installed = vim.tbl_filter(function(lang)
    --       if added[lang] then
    --         return false
    --       end
    --       added[lang] = true
    --       return true
    --     end, opts.ensure_installed)
    --   end
    --   require("nvim-treesitter.configs").setup(opts)
    --
    --   local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    --   parser_config.erb = {
    --     install_info = {
    --       url = "https://github.com/tree-sitter/tree-sitter-embedded-template",
    --       files = { "src/parser.c" },
    --       requires_generate_from_grammar = true,
    --     },
    --     filetype = "erb",
    --   }
    -- end,
  },

  {
    "IndianBoy42/tree-sitter-just",

    config = true,
  },
}
