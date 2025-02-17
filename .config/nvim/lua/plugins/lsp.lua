return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = function()
      return {
        servers = {
          bashls = {},
          pylsp = {},
          jedi_language_server = {},
          pyright = {},
          ruby_lsp = {},
          solargraph = {},
          gopls = {},
          sqlls = {},
          lua_ls = {
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = { library = { vim.env.VIMRUNTIME } }
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
        },
        -- options for vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "blah",
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
          enabled = true,
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
      }
    end,
    config = function(_, opts)
      require("mason").setup()
      local mlsp = require("mason-lspconfig")
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {}
      for server_name, server_opts in pairs(opts.servers) do
        -- Setup through mason lsp if it's available in that plugin, otherwise directly
        if vim.tbl_contains(all_mslp_servers, server_name) then
          ensure_installed[#ensure_installed + 1] = server_name
        else
          require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
            on_attach = opts.on_attach,
            capabilities = opts.capabilities,
            inlay_hints = opts.inlay_hints,
          }, server_opts))
        end
      end
      mlsp.setup({ ensure_installed = ensure_installed })
      mlsp.setup_handlers {
        function(server_name)
          local server_opts = opts.servers[server_name] or {}
          --print("Setting up " .. server_name .. " with " .. vim.inspect(server_opts))
          require("lspconfig")[server_name].setup(vim.tbl_deep_extend("force", {
              on_attach = opts.on_attach,
              capabilities = opts.capabilities,
              inlay_hints = opts.inlay_hints,
            },
            server_opts))
        end
      }

      --
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
          --vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
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

          local client = vim.lsp.get_client_by_id(ev.data.client_id)

          -- Format the current buffer on save
          vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = ev.buf,
            callback = function()
              vim.lsp.buf.format({ bufnr = ev.buf })
            end,
          })
        end,
      })
    end
  },
}
