---@module "rustaceanvim"
---@module "lazyvim"

local pretty_printer_path = vim.fn.stdpath("config") .. "/pretty_printer.py"
local function load_dap_configuration(type)
  -- default
  ---@type rustaceanvim.dap.client.Config
  local dap_config = {
    name = "Rust debug client",
    type = type,
    request = "launch",
    stopOnEntry = false,
    initCommands = {
      "command script import " .. pretty_printer_path,
    },
  }
  if type == "lldb" then
    ---@diagnostic disable-next-line: inject-field
    dap_config.runInTerminal = true
  end
  ---@diagnostic disable-next-line: different-requires
  local dap = require("dap")
  -- Load configurations from a `launch.json`.
  -- It is necessary to check for changes in the `dap.configurations` table, as
  -- `load_launchjs` does not return anything, it loads directly into `dap.configurations`.
  local pre_launch = vim.deepcopy(dap.configurations) or {}
  for name, configuration_entries in pairs(dap.configurations) do
    if pre_launch[name] == nil or not vim.deep_equal(pre_launch[name], configuration_entries) then
      -- `configurations` are tables of `configuration` entries
      -- use the first `configuration` that matches
      for _, entry in pairs(configuration_entries) do
        ---@cast entry rustaceanvim.dap.client.Config
        if entry.type == type then
          dap_config = entry
          break
        end
      end
    end
  end
  return dap_config
end

return {
  "mrcjkb/rustaceanvim",
  opts = function()
    ---@type rustaceanvim.Opts
    return {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            diagnostics = {
              disabled = {
                "non_snake_case",
              },
            },
            procMacro = {
              enable = true,
              ignored = {
                -- ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
                leptos_macro = {
                  -- "component",
                  -- "server",
                },
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    if LazyVim.has("mason.nvim") then
      local package_path = vim.fn.exepath("codelldb")
      local codelldb = package_path .. "/extension/adapter/codelldb"
      local library_path = package_path .. "/extension/lldb/lib/liblldb.dylib"
      local uname = io.popen("uname"):read("*l")
      if uname == "Linux" then
        library_path = package_path .. "/extension/lldb/lib/liblldb.so"
      end
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
        configuration = function()
          return load_dap_configuration("codelldb")
        end,
      }
    end
    vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    if vim.fn.executable("rust-analyzer") == 0 then
      vim.notify("**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/")
    end
  end,
}
