return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "alfaix/neotest-gtest",
    },
    opts = function(_, opts)
      local wk = require("which-key")
      -- check if current buffer is a cpp file
      -- if so, add keybindings for gtest
      if vim.bo.filetype == "cpp" then
        require("neotest-gtest.executables").set_summary_autocmd()
        wk.register({
          t = {
            x = { "<cmd>ConfigureGtest<CR>", "Change Executable" },
          },
        }, { prefix = "<leader>" })
      end

      table.insert(opts.adapters, "neotest-gtest")
    end,
  },
}
