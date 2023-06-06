return {
  {
    "williamboman/mason.nvim",

    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "clangd",
        "elixir-ls",
        "erb-lint",
        "json-lsp",
        "lua-language-server",
        "nil",
        "pyright",
        "shfmt",
        "solargraph",
        "standardrb",
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
    "jose-elias-alvarez/null-ls.nvim",

    opts = function(_, opts)
      -- opts.debug = true

      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.erb_lint.with({
          only_local = ".bin",
        }),
        nls.builtins.formatting.erb_lint.with({
          only_local = ".bin",
        }),
      })
    end,
  },

  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   -- event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --   },
  --   opts = {
  --     automatic_setup = true,
  --     -- A list of sources to install if they're not already installed.
  --     -- This setting has no relation with the `automatic_installation` setting.
  --     ensure_installed = {},
  --     -- Run `require("null-ls").setup`.
  --     -- Will automatically install masons tools based on selected sources in `null-ls`.
  --     -- Can also be an exclusion list.
  --     -- Example: `automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }`
  --     automatic_installation = false,
  --   },
  -- },

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

    -- init = function()
    --   vim.lsp.set_log_level("debug")
    -- end,

    -- solargraph seems to have a bug where it won't disable formatting; override it
    opts = function(_, opts)
      opts.format = vim.tbl_extend("force", opts.format or {}, {
        filter = function(client)
          local buf = vim.api.nvim_get_current_buf()
          if vim.b.autoformat == false and not (opts and opts.force) then
            return
          end
          local ft = vim.bo[buf].filetype
          local have_nls = package.loaded["null-ls"]
            and (#require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0)

          if have_nls then
            return client.name == "null-ls"
          end
          return client.name ~= "null-ls" and client.name ~= "solargraph"
        end,

        timeout_ms = 2000,
      })
    end,
  },
}
