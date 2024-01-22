-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- add usercommands
require("config.commands")
-- add mouse context entries
require("config.mouse_context_menu")

vim.diagnostic.config({
  float = { border = "rounded" },
})
