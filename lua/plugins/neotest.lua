return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "alfaix/neotest-gtest",
      "rouge8/neotest-rust",
    },
    opts = function(_, opts)
      local wk = require("which-key")
      -- check if current buffer is a cpp file
      -- if so, add keybindings for gtest
      if vim.bo.filetype == "cpp" then
        require("neotest-gtest.executables").set_summary_autocmd()
        wk.add({
          {
            "<leader>tx",
            "<cmd>ConfigureGtest<CR>",
            desc = "Change Executable",
            mode = "n",
          },
        })
      end

      local pretty_printer_path = vim.fn.stdpath("config") .. "/pretty_printer.py"
      -- Patch for neotest-rust: override build_spec, if dap mode is used to enable
      -- pretty printing script
      local rust_adapter = require("neotest-rust")
      local orig_build_spec = rust_adapter.build_spec
      rust_adapter.build_spec = function(args)
        local spec = orig_build_spec(args)
        if args.strategy == "dap" and spec.strategy and spec.strategy.type == "codelldb" then
          spec.strategy.initCommands = {
            "command script import " .. pretty_printer_path,
          }
        end
        return spec
      end

      table.insert(opts.adapters, rust_adapter)
      table.insert(opts.adapters, "neotest-gtest")
      opts.adapters["neotest-golang"] = {
        go_test_args = {
          "-v",
          "-race",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }
    end,
  },
}
