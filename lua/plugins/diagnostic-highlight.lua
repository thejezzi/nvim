return {
  {
    "Kasama/nvim-custom-diagnostic-highlight",
    init = function()
      local deprecated_handler = require("nvim-custom-diagnostic-highlight").setup({
        register_handler = false,
        highlight_group = "LSPDeprecated",
        patterns_override = { "deprecated" },
        diagnostic_handler_namespace = "deprecated_handler",
      })
      vim.cmd([[highlight LSPDeprecated guifg=#5C6370 gui=strikethrough]])
      vim.diagnostic.handlers["my/deprecated"] = deprecated_handler
    end,
  },
}
