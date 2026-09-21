return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "alfaix/neotest-gtest",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      -- LazyVim's Rust extra supplies this as the only Rust adapter. It routes
      -- Neotest's standard <leader>t mappings through rustaceanvim's DAP flow.
      opts.adapters["rustaceanvim.neotest"] = {}

      local wk = require("which-key")
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

      table.insert(opts.adapters, "neotest-gtest")
      opts.adapters["neotest-golang"] = {
        warn_test_name_dupes = false,
        go_test_args = {
          "-v",
          "-race",
          "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
        },
      }
      opts.adapters["neotest-python"] = require("neotest-python")
    end,
  },
}
