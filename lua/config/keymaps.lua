-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--- Maps a key combination to a Neovim command.
-- This function simplifies the assignment of key mappings in Neovim.
--
-- @param mode string: The mode in which the key mapping is active. Common modes include
--                     'n' for Normal, 'i' for Insert, 'v' for Visual, etc.
-- @param lhs string: The key combination to be mapped.
--                    For example, '<leader>e' for a leader key combination.
-- @param rhs string: The Neovim command or sequence of keys that should be executed
--                    when the key combination is pressed.
-- @param opts table: (optional) A table of additional options for the key mapping.
--                    By default, {'noremap': true} is used to avoid recursive mappings.
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--- Maps a key combination to a Neovim command with a description.
-- This function extends the `map` function by adding a description for the key mapping.
--
-- @param mode string: The mode in which the key mapping is active. Common modes include
--                     'n' for Normal, 'i' for Insert, 'v' for Visual, etc.
-- @param lhs string: The key combination to be mapped.
--                    For example, '<leader>e' for a leader key combination.
-- @param rhs string: The Neovim command or sequence of keys that should be executed
--                    when the key combination is pressed.
-- @param desc string: A description of what the key mapping does. This description
--                     is stored as a buffer variable and can be retrieved later.
-- @param opts table: (optional) A table of additional options for the key mapping.
--                    Inherits the same optional behavior as in the `map` function.
local function map_desc(mode, lhs, rhs, desc, opts)
  map(mode, lhs, rhs, opts)
  vim.api.nvim_buf_set_var(0, "mapleader_desc_" .. lhs, desc)
end

--- Maps multiple key combinations in given modes.
-- This function allows for mapping multiple key combinations across different modes using a compact format.
-- Each mapping is defined in a table containing the mode(s), lhs, rhs, and optionally a description and options.
--
-- @param mappings table: A list of mappings where each mapping is defined in a table.
--                        Format of each mapping: { "mode,modes...", "lhs", "rhs", "desc(optional)", {opts(optional)} }
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
  -- additonal go keymaps
  { "n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", "LSP Hover" },
  -- open alpha again
  { "n", "<leader>oa", "<cmd>Alpha<CR>", "Open Alpha" },

  -- Telescope diagnostics
  { "n", "<leader>xd", "<cmd>Telescope diagnostics<CR>", "Document Diagnostics" },
  -- Jump to next diagnostic
  { "n", "<leader>xn", "<cmd>lua vim.diagnostic.goto_next()<CR>", "Next Diagnostic" },
  -- Jump to previous diagnostic
  { "n", "<leader>xN", "<cmd>lua vim.diagnostic.goto_prev()<CR>", "Previous Diagnostic" },
})
