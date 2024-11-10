return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
          -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          -- prefix = "icons",
        },
        severity_sort = true,
      },
      -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the inlay hints.
      inlay_hints = {
        enabled = false,
      },
      -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
      -- Be aware that you also will need to properly configure your LSP server to
      -- provide the code lenses.
      codelens = {
        enabled = false,
      },
      -- add any global capabilities here
      capabilities = {},
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      -- We define servers here instead of opts to let us use util.root_pattern in the config
      -- There's probably another way though...
      local servers = {
        bashls = {},
        pylsp = {},
        solargraph = {},
        gopls = {},
        sqlls = {},
        lua_ls = {
          opts = {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = { library = { vim.env.VIMRUNTIME } }
              }
            }
          }
        },
        jsonls = {
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

      require("mason").setup()
      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {}
      for server_name, server_opts in pairs(servers) do
        -- Setup through mason lsp if it's available in that plugin, otherwise directly
        if vim.tbl_contains(all_mslp_servers, server_name) then
          ensure_installed[#ensure_installed + 1] = server_name
        else
          require("lspconfig")[server_name].setup(server_opts)
        end
      end
      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers {
        function(server_name)
          local server_opts = servers[server_name] or {}
          require("lspconfig")[server_name].setup(server_opts)
        end
      }

      vim.lsp.set_log_level("DEBUG")
      vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        callback = function()
          vim.lsp.buf.format()
        end,
      })

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<space>F", function()
            vim.lsp.buf.format({ async = true })
          end, opts)
        end,
      })
    end

  },
}
