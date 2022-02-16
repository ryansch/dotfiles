local M = {}

local lspconfig = require 'lspconfig'
local lsputil = require("lspconfig.util")
local lsp_status = require("lsp-status")
lsp_status.config {
  current_function = false,
  diagnostics = false,
  status_symbol = '',
}
lsp_status.register_progress()

local function on_attach(client, bufnr)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

  lsp_status.on_attach(client)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities = vim.tbl_extend('keep', capabilities or {}, lsp_status.capabilities)

local function dir_has_file(dir, name)
  return lsputil.path.exists(lsputil.path.join(dir, name)), lsputil.path.join(dir, name)
end

local function workspace_root()
  local cwd = vim.loop.cwd()

  if dir_has_file(cwd, "compose.yml") or dir_has_file(cwd, "docker-compose.yml") then
    return cwd
  end

  local function cb(dir, _)
    return dir_has_file(dir, "compose.yml") or dir_has_file(dir, "docker-compose.yml")
  end

  local root, _ = lsputil.path.traverse_parents(cwd, cb)
  return root
end

--- Build the language server command.
-- @param opts options
-- @param opts.locations table Locations to search relative to the workspace root
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
-- @return a string containing the command
local function language_server_cmd(opts)
  opts = opts or {}
  local fallback_dir = opts.fallback_dir
  local locations = opts.locations or {}

  local root = workspace_root()
  if not root then
    root = vim.loop.cwd()
  end

  for _, location in ipairs(locations) do
    local exists, dir = dir_has_file(root, location)
    if exists then
      logger.fmt_debug("language_server_cmd: %s", vim.fn.expand(dir))
      return vim.fn.expand(dir)
    end
  end

  local fallback = vim.fn.expand(fallback_dir)
  logger.fmt_debug("language_server_cmd: %s", fallback)
  return fallback
end

--- Build the elixir-ls command.
-- @param opts options
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
local function elixirls_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      locations = {
        ".elixir-ls-release/language_server.sh",
        ".elixir_ls/release/language_server.sh",
      },
    }
  )

  opts.fallback_dir = opts.fallback_dir or vim.env.XDG_DATA_HOME or "~/.local/share"
  opts.fallback_dir = string.format("%s/lsp/elixir-ls/%s", opts.fallback_dir, "language_server.sh")

  return language_server_cmd(opts)
end

--- Build the solargraph command.
-- @param opts options
-- @param opts.fallback_dir string Path to use if locations don't contain the binary
local function solargraph_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      locations = {
        ".bin/solargraph",
      },
    }
  )

  opts.fallback_dir = opts.fallback_dir or vim.env.XDG_DATA_HOME or "~/.local/share"
  opts.fallback_dir = string.format("%s/lsp/solargraph/%s", opts.fallback_dir, "solargraph")

  return language_server_cmd(opts)
end

local function tsserver_cmd(opts)
  opts = opts or {}
  opts = vim.tbl_deep_extend(
    "force",
    opts,
    {
      locations = {
        ".bin/typescript-language-server",
      },
    }
  )

  opts.fallback_dir = opts.fallback_dir or vim.env.XDG_DATA_HOME or "~/.local/share"
  opts.fallback_dir = string.format("%s/lsp/tsserver/%s", opts.fallback_dir, "typescript-language-server")

  return language_server_cmd(opts)
end

function M.setup()
  -- Enable the following language servers
  local servers = { 'clangd', 'rust_analyzer', 'pyright' }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
    }
  end

  vim.lsp.set_log_level("trace")
  require("vim.lsp.log").set_format_func(vim.inspect)

  lspconfig.elixirls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { elixirls_cmd() },
    settings = {
      elixirLS = {
        mixEnv = "test",
      }
    }
  }

  lspconfig.solargraph.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { solargraph_cmd(), "stdio" },
    settings = {
      solargraph = {
        folding = false,
        logLevel = "debug",
      }
    }
  }

  lspconfig.tsserver.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { tsserver_cmd(), "--stdio" },
    init_options = {
      hostInfo = "neovim",
      logVerbosity = "verbose"
    }
  }

  -- Example custom server
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- luasnip setup
  local luasnip = require 'luasnip'
  luasnip.filetype_extend("ruby", {"rails"})

  -- TODO: Figure out how to get autocomplete working for snippets
  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }
end

return M
