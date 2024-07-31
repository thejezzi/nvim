return {
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    init = function()
      require("coverage").setup()
      require("which-key").add({
        {
          "<leader>tc",
          "<cmd>CoverageLoad<CR><cmd>CoverageShow<CR>",
          desc = "Show coverage",
          mode = "n",
          icon = "󱖫",
        },
      })
    end,
  },
}
