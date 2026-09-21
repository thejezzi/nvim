local wk = require("which-key")

wk.add({
  { "<leader>ce", "<cmd>EpicHover<cr>", desc = "Hover over a Date", mode = "n" },
  { "<leader>cE", "<cmd>EpicConvert<cr>", desc = "Convert a Date", mode = "n" },
  { "<leader>cE", ":EpicConvert<cr>", desc = "Convert a Date", mode = "v" },
})

return {
  "thejezzi/epic.nvim",
  opts = {},
}
