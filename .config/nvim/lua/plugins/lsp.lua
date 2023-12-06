return {
  { "folke/lazy.nvim", tag = "stable" },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    --lazy = true,
    config = function(_, opts)
      servers = {
        bashls = {},
        pylsp = {},
        solargraph = {},
        gopls = {},
        sqlls = {
          cmd = { "/opt/homebrew/bin/sql-language-server" },
        },
        lua_ls = {
          cmd = { "/opt/local/bin/lua-language-server" },
          opts = {
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT'
                },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' }
                },
                --                diagnostics = {
                --                  -- Get the language server to recognize the `vim` global
                --                  globals = { 'vim' }
                --                },
                workspace = {
                  library = { vim.env.VIMRUNTIME }
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                }
              }
            }
          }
        },
        jsonls = {
          cmd = { "/Users/dancorne/.npm-global/bin/vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc", "json.tftpl" },
        },
        terraformls = {
          filetypes = { "terraform", "tfvars", "hcl" },
          root_dir = require("lspconfig").util.root_pattern("vars.tf", "variables.tf", ".git")
        },
        tflint = {
          filetypes = { "terraform", "hcl" },
          root_dir = require("lspconfig").util.root_pattern("vars.tf", "variables.tf", ".git")
        },

      }
      for server, server_opts in pairs(servers) do
        require("lspconfig")[server].setup(server_opts)
      end
      vim.lsp.set_log_level("DEBUG")
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end

  },
  --  {
  --    'VonHeikemen/lsp-zero.nvim',
  --    branch = 'v2.x',
  --    dependencies = {
  --      -- LSP Support
  --      { 'neovim/nvim-lspconfig' },             -- Required
  --      { 'williamboman/mason.nvim' },           -- Optional
  --      { 'williamboman/mason-lspconfig.nvim' }, -- Optional
  --
  --      -- Autocompletion
  --      { 'hrsh7th/nvim-cmp' },     -- Required
  --      { 'hrsh7th/cmp-nvim-lsp' }, -- Required
  --      { 'L3MON4D3/LuaSnip' },     -- Required
  --    },
  --    config = function()
  --      local lsp = require('lsp-zero').preset({})
  --      lsp.on_attach(function(client, bufnr)
  --        -- see :help lsp-zero-keybindings
  --        -- to learn the available actions
  --        lsp.default_keymaps({ buffer = bufnr })
  --      end)
  --      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
  --      lsp.setup()
  --    end
  --  }
  --  {
  --    "williamboman/mason-lspconfig.nvim",
  --    cmd = { "LspInstall", "LspUninstall" },
  --    --    config = function()
  --    --      require("mason-lspconfig").setup(lvim.lsp.installer.setup)
  --    --
  --    --      -- automatic_installation is handled by lsp-manager
  --    --      local settings = require "mason-lspconfig.settings"
  --    --      settings.current.automatic_installation = false
  --    --    end,
  --    lazy = true,
  --    event = "User FileOpened",
  --    --dependencies = "mason.nvim",
  --  },
  {
    "williamboman/mason.nvim",
    --    config = function()
    --      require("lvim.core.mason").setup()
    --    end,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    event = "User FileOpened",
    lazy = true,
  },
}
