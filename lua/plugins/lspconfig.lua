return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      inlay_hints = {
        enabled = false,
      },
      servers = {
        sqls = {
          cmd = {
            "sqls",
            "-config",
            vim.fn.expand("~/.config/sqls/config.yml"),
          },
        },
        amber_lsp = {
          mason = false,
          cmd = { "amber-lsp" },
          filetypes = { "amber" },
          single_file_support = true,
          root_dir = require("lspconfig.util").root_pattern("amber.toml", ".git"),
        },
        jsonls = {
          filetypes = { "json", "jsonc", "json5" },
        },
        gopls = {
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = true,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        amber_lsp = function(_, opts)
          local lspconfig = require("lspconfig")
          local configs = require("lspconfig.configs")

          if not configs.amber_lsp then
            configs.amber_lsp = {
              default_config = {
                cmd = { "amber-lsp" },
                filetypes = { "amber" },
                single_file_support = true,
                root_dir = require("lspconfig.util").root_pattern("amber.toml", ".git"),
              },
            }
          end

          lspconfig.amber_lsp.setup(opts)
          return true
        end,
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require("snacks.util").lsp.on(function(_, client)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,

        -- disable clangd on proto files as we need bufls to handle protobuf files
        clangd = function(_, opts)
          opts.filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }
        end,
        groovyls = function(_, opts)
          opts.filetypes = { "groovy", "jenkinsfile" }
        end,
      },
    },
  },
}
