-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.colorcolumn = "80,100"
-- opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 10

local g = vim.g

g.semantic_tokens_enabled = true
