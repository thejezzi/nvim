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

local wk = require("which-key")

wk.register({
  o = {
    name = "open",
    a = { "<cmd>Alpha<CR>", "Open Alpha" },
    t = { "<cmd>ToggleTerm size=20 direction=horizontal<cr>", "Horizontal terminal" },
    f = { "<cmd>ToggleTerm size=20 direction=float<cr>", "Floating terminal" },
    v = { "<cmd>ToggleTerm size=90 direction=vertical<cr>", "Vertical terminal" },
  },
  x = {
    d = { "<cmd>Telescope diagnostics<CR>", "Document Diagnostics" },
    n = { "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
    N = { "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous Diagnostic" },
  },
  g = {
    d = {
      name = "Diffview",
      d = { "<cmd>DiffviewOpen<CR>", "Open Diffview" },
      c = { "<cmd>DiffviewClose<CR>", "Close Diffview" },
    },
    r = { "<cmd>DiffviewRefresh<CR>", "Refresh Diffview" },
    h = { "<cmd>DiffviewFileHistory<CR>", "File History" },
  },
  z = {
    name = "ollama",
    mode = { "n", "v" },
    g = { mode = "n", "<cmd>Gen<CR>", "gen" },
    c = { mode = "n", "<cmd>Gen Chat<CR>", "chat" },
    a = { mode = "v", ":'<,'>Gen Ask<CR>", "ask with prompt" },
    h = { mode = "v", ":'<,'>Gen Change<CR>", "change selected text" },
    e = { mode = "v", ":'<,'>Gen Enhance_Grammar_Spelling<CR>", "enhance grammar" },
    r = { mode = "v", ":'<,'>Gen Review_Code<CR>", "review code" },
    s = { mode = "v", ":'<,'>Gen Summarize<CR>", "summarize" },
  },
}, { prefix = "<leader>" })
