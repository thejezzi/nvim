-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function map_desc(mode, lhs, rhs, desc, opts)
  map(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_var(0, "mapleader_desc_" .. lhs, desc)
end

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
  -- additonal goto keymaps
  { "n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP Hover" },
  { "t", "<Esc>", "<C-\\><C-n>" },
  { "n", "<leader>zg", "<cmd>Gen<CR>" },
  { "n", "<leader>zc", "<cmd>Gen Chat<CR>" },
  { "v", "<leader>za", ":'<,'>Gen Ask<CR>" },
  { "v", "<leader>zh", ":'<,'>Gen Change<CR>" },
  { "v", "<leader>ze", ":'<,'>Gen Enhance_Grammar_Spelling<CR>" },
  { "v", "<leader>zr", ":'<,'>Gen Review_Code<CR>" },
  { "v", "<leader>zs", ":'<,'>Gen Summarize<CR>" },
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
      r = { "<cmd>DiffviewRefresh<CR>", "Refresh Diffview" },
      h = { "<cmd>DiffviewFileHistory<CR>", "File History" },
    },
  },
  z = {
    name = "Ollama",
    -- e = { "<cmd>Gen Enhance_Grammar_Spelling<CR>", "Enhance Grammar Spelling" },
  },
}, { prefix = "<leader>" })
