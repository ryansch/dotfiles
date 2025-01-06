-- Force erblint to use the .bin stub
local finders = require("util.finders")

local erb_lint = require("lint").linters.erb_lint
if finders.file_exists_in_cwd(".bin/erblint") then
  erb_lint.args = { "exec", ".bin/erblint", "--format", "compact" }
end

return {
  {
    "williamboman/mason.nvim",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "clangd",
        "elixir-ls",
        "json-lsp",
        "lua-language-server",
        "nil",
        "pyright",
        "shellcheck",
        "shfmt",
        "stylua",
        "tailwindcss-language-server",
        "terraform-ls",
        "typescript-language-server",
        "yaml-language-server",
      })

      opts.PATH = "append"
    end,
  },

  {
    "conform.nvim",

    -- opts = function(_, opts)
    --   opts.formatters_by_ft = {
    --     eruby = { "erb_format" },
    --   }
    -- end,
  },

  {
    "nvim-lint",

    opts = {
      linters_by_ft = {
        eruby = { "erb_lint" },
      },
    },
  },

  {
    "folke/neoconf.nvim",

    dependencies = {
      { "ryansch/neoconf-lspcmd" },
      { "nvim-lua/plenary.nvim" },
    },

    opts = function(_, opts)
      opts.plugins = vim.tbl_extend("force", opts.plugins or {}, {
        lspcmd = {
          enabled = true,
          log_level = "info",
          ls_mappings = {
            ruby_ls = "rubyLsp",
            standardrb = "standardRuby",
            yamlls = "yaml",
          },
        },
      })
    end,

    config = function(_, opts)
      require("neoconf").setup(opts)
      require("neoconf.plugins").register(require("neoconf-lspcmd"))
    end,
  },

  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        dockerls = {
          settings = {
            docker = {
              languageserver = {
                formatter = {
                  ignoreMultilineInstructions = true,
                },
              },
            },
          },
        },
        harper_ls = {
          settings = {
            ["harper-ls"] = {
              userDictPath = "~/.config/harper_ls",
            },
          },
        },
      },
    },

    -- init = function()
    --   vim.lsp.set_log_level("debug")
    -- end,
  },
}
