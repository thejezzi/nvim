---@module "noice"
return {
  {
    "folke/noice.nvim",
    --- @diagnostic disable: missing-fields
    --- @type NoiceConfig
    opts = {
      presets = {
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "notify",
            find = "Copilot",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "cmdline",
            find = "Copilot",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
