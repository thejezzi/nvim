---@module "overseer"

local wk = require("which-key")

wk.add({
  { "<leader>o", group = "Overseer", icon = "󱨧" },
  { "<leader>oo", "<cmd>OverseerToggle<CR>", desc = "Toggle Overseer" },
  { "<leader>or", "<cmd>OverseerRun<CR>", desc = "Run a command with Overseer" },
  { "<leader>oc", "<cmd>OverseerRunCmd<CR>", desc = "Run a command template with Overseer" },
})

return {
  "stevearc/overseer.nvim",
  ---@type overseer.Config
  opts = {
    task_list = {
      min_height = 20,
    },
  },
}
