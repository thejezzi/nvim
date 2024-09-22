-- This file is for custom commands prefixed with CC

-- CCChangeFileType opens a window with a selection of all available
-- filetypes to change the current filetype
vim.api.nvim_create_user_command("CustomChangeFileType", function()
  require("lib").change_filetype_window()
end, {})
