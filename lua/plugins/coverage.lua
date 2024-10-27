return {
  {
    "thejezzi/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      require("coverage").setup({
        lang = {
          rust = {
            coverage_command = "cargo llvm-cov -q --lcov --output-path coverage.out",
            project_files_only = false,
            coverage_file = "coverage.out",
          },
        },
      })
      require("which-key").add({
        {
          "<leader>tc",
          "<cmd>Coverage<CR>",
          desc = "Create coverage report and show",
          mode = "n",
          icon = "󱖫",
        },
        {
          "<leader>tC",
          "<cmd>CoverageToggle<CR>",
          desc = "Toggle coverage report on/off",
          mode = "n",
          icon = "󱖫",
        },
      })
    end,
  },
}
