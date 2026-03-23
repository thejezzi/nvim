---@module "sidekick"
return {
  "folke/sidekick.nvim",
  ---@type sidekick.Config
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      win = {
        keys = {
          {
            "<M-Esc>",
            "<Esc>",
            mode = "t",
            desc = "Interrupt AI Agent",
          },
        },
      },
    },
  },
}
