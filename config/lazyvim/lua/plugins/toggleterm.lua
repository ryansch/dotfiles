return {
  {
    "akinsho/toggleterm.nvim",

    opts = function(_, opts)
      local util = require("util")

      local config = {
        desk_integration = true,
      }

      local function on_first_open(term)
        if config.desk_integration then
          if util.workspace_has_file("Deskfile") then
            term:send("eval $(desk load)")
          end
        end
      end

      return {
        size = function(term)
          if term.direction == "horizontal" then
            return 20
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        shade_terminals = false,
        persist_size = false,
        persist_mode = true,
        on_open = function(term)
          term.opened = term.opened or false

          if not term.opened then
            on_first_open(term)
          end

          term.opened = true
        end,
        auto_scroll = false,
      }
    end,

    config = function(_, opts)
      require("toggleterm").setup(opts)

      function _G.set_terminal_keymaps()
        local keymap_opts = { buffer = true }
        vim.keymap.set("t", "<C-v><Esc>", [[<C-\><C-n>]], keymap_opts)
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], keymap_opts)
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], keymap_opts)
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], keymap_opts)
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], keymap_opts)
      end

      -- if you only want these mappings for toggle term use term://*toggleterm#* instead
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
    end,

    cmd = {
      "ToggleTerm",
      "ToggleTermToggleAll",
      "TermExec",
      "TermSelect",
      "ToggleTermSendCurrentLine",
      "ToggleTermSendVisualLines",
      "ToggleTermSendVisualSelection",
      "ToggleTermSetName",
    },

    keys = {
      {
        "<leader>tf",
        function()
          require("toggleterm").toggle(vim.v.count, nil, nil, "float")
        end,
        desc = "ToggleTerm Float",
      },
      {
        "<leader>th",
        function()
          require("toggleterm").toggle(vim.v.count, nil, nil, "horizontal")
        end,
        desc = "ToggleTerm Horizontal",
      },
      {
        "<leader>tv",
        function()
          require("toggleterm").toggle(vim.v.count, nil, nil, "vertical")
        end,
        desc = "ToggleTerm Vertical",
      },
      {
        "<leader>tc",
        function()
          local terms = require("toggleterm.terminal")
          local terminals = terms.get_all()

          for _, term in pairs(terminals) do
            if term:is_open() then
              term:close()
            end
          end
        end,
        desc = "Close all terminals",
      },
      {
        "<leader>tt",
        "<cmd>TermSelect<cr>",
        desc = "Find terminals",
      },
    },
  },
}
