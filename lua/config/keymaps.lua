-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Maps a key or command to a mode.
--
-- @param mode The Vim mode (e.g. "n", "v", etc.)
-- @param lhs The left-hand side of the mapping (e.g. "j" for the 'j' key)
-- @param rhs The right-hand side of the mapping (e.g. a function or command to be executed)
-- @param opts Optional additional options to pass to the `vim.api.nvim_set_keymap` function
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Maps a key or command to a mode with an optional description.
--
-- @param mode The Vim mode (e.g. "n", "v", etc.)
-- @param lhs The left-hand side of the mapping (e.g. "j" for the 'j' key)
-- @param rhs The right-hand side of the mapping (e.g. a function or command to be executed)
-- @param desc An optional description for the mapping
-- @param opts Any additional options to pass to the `map` function
local function map_desc(mode, lhs, rhs, desc, opts)
  map(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_var(0, "mapleader_desc_" .. lhs, desc)
end

-- Maps multiple key bindings to Vim modes.
--
-- @param mappings A table of key binding mappings, where each mapping is a table
--                 containing mode(s), lhs, rhs, description and options (see map_desc).
local function map_multiple(mappings)
  for _, mapping in ipairs(mappings) do
    local modeStr, lhs, rhs, desc, opts = unpack(mapping)
    local modes = vim.split(modeStr, ",")

    for _, mode in ipairs(modes) do
      local options = opts or {}
      map_desc(mode, lhs, rhs, desc or "No description", options)
    end
  end
end

map_multiple({
  { "n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP Hover" },
  { "t", "<Esc>", "<C-\\><C-n>" },
})

require("which-key").add({
  -- Dadbod keymaps
  { "<leader>D", group = "Dadbod", icon = "" },
  { "<leader>Da", "<cmd>DBUIAddConnection<CR>", desc = "Add DB Connection" },
  { "<leader>Dd", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
  { "<leader>Df", "<cmd>DBUIFindBuffer<CR>", desc = "Find Buffer" },
  { "<leader>Dh", "<cmd>DBUIHideNotifications<CR>", desc = "Hide Notifications" },
  { "<leader>Dl", "<cmd>DBUILastQueryInfo<CR>", desc = "Last Query Info" },
  { "<leader>Dr", "<cmd>DBUIRenameBuffer<CR>", desc = "Rename Buffer" },
  --
  -- Diffview
  { "<leader>gd", group = "Diffview", icon = "󱩾" },
  { "<leader>gdc", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
  { "<leader>gdd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
  { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File History" },
  { "<leader>gr", "<cmd>DiffviewRefresh<CR>", desc = "Refresh Diffview" },
  --
  -- Everyhting to open stuff
  { "<leader>O", group = "open", icon = "󰏌" },
  { "<leader>Oa", "<cmd>Alpha<CR>", desc = "Open Alpha", icon = "󰧨" },
  { "<leader>Of", "<cmd>ToggleTerm size=20 direction=float<cr>", desc = "Floating terminal" },
  { "<leader>Ot", "<cmd>ToggleTerm size=20 direction=horizontal<cr>", desc = "Horizontal terminal" },
  { "<leader>Ov", "<cmd>ToggleTerm size=90 direction=vertical<cr>", desc = "Vertical terminal" },
  --
  -- Preview extension similar to lsp saga priview
  { "<leader>p", group = "Preview", icon = "" },
  { "<leader>pp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview Definition" },
  { "<leader>pD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview Declaration" },
  { "<leader>pr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview References" },
  {
    "<leader>pt",
    "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
    desc = "Preview Type Definition",
  },
  {
    "<leader>pi",
    "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
    desc = "Preview Implementation",
  },
  { "<leader>pP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close All Windows" },
  --
  -- Diagnostics
  { "<leader>xN", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Previous Diagnostic" },
  { "<leader>xd", "<cmd>Telescope diagnostics<CR>", desc = "Document Diagnostics" },
  { "<leader>xn", "<cmd>lua vim.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
  --
  -- Gen.nvim
  { "<leader>zc", "<cmd>Gen Chat<CR>", desc = "chat" },
  { "<leader>zg", "<cmd>Gen<CR>", desc = "gen" },
  { "<leader>z", group = "ollama", mode = { "n", "v" }, icon = "󱄔" },
  {
    mode = { "v" },
    { "<leader>za", ":'<,'>Gen Ask<CR>", desc = "ask with prompt" },
    { "<leader>ze", ":'<,'>Gen Enhance_Grammar_Spelling<CR>", desc = "enhance grammar" },
    { "<leader>zh", ":'<,'>Gen Change<CR>", desc = "change selected text" },
    { "<leader>zr", ":'<,'>Gen Review_Code<CR>", desc = "review code" },
    { "<leader>zs", ":'<,'>Gen Summarize<CR>", desc = "summarize" },
  },
  {
    mode = { "n" },
    { "<leader>F", group = "features", mode = { "n" }, icon = "󱁕" },
    { "<leader>Fc", ":Copilot toggle<CR>", desc = "toggle copilot on or off" },
  },
  {
    { "<leader>y", group = "NeovimCode" },
    { "<leader>yy", ":lua<CR>", mode = "v" },
    { "<leader>yy", "<cmd>source %<CR>", mode = "n" },
    { "<leader>yl", ":.lua<CR>", mode = "n" },
  },
}, { prefix = "<leader>" })
