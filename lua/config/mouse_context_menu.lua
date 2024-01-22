-- This file contains all options that are added to the right click mouse
-- menu

vim.cmd.aunmenu([[PopUp.How-to\ disable\ mouse]])
vim.cmd.amenu([[PopUp.Inspect <Cmd>Inspect<CR>]])
vim.cmd.amenu([[PopUp.Telescope <Cmd>Telescope<CR>]])
vim.cmd.amenu([[PopUp.Code\ action <Cmd>lua vim.lsp.buf.code_action()<CR>]])
vim.cmd.amenu([[PopUp.LSP\ Hover <Cmd>lua vim.lsp.buf.hover()<CR>]])
vim.cmd.amenu([[PopUp.Toggle\ Breakpoint <Cmd>lua require("dap").toggle_breakpoint()<CR>]])
