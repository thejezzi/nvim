local stringutil = require("lib.stringutil")

local M = {}

---Normalizes language definitions into a group name and a sorted list of patterns.
--
---This function takes a string or a table of strings representing language names or patterns.
---It normalizes these into a consistent group name suffix and a sorted table of language patterns.
---If an empty or nil input is provided, it returns early.
---Wildcard "*" is handled specially for the group name.
---
---@param langs string|table A string or table of strings representing language names or patterns.
---@return string group_name The generated group name for the language patterns, or nil if no patterns.
---@return table lang_patterns The sorted table of normalized language patterns, or nil if no patterns.
local function _normalize_lang_definitions(langs)
  local lang_patterns
  if type(langs) == "string" then
    lang_patterns = { langs }
  else
    lang_patterns = langs
  end
  assert(type(lang_patterns) == "table", "Expected langs to be a string or a table of strings")
  assert(#lang_patterns > 0, "Expected langs to be a non-empty string or table")
  table.sort(lang_patterns)

  local capitalized_names = {}
  for _, lang_name in ipairs(lang_patterns) do
    if lang_name ~= "*" then
      table.insert(capitalized_names, stringutil.capitilize(lang_name))
    else
      table.insert(capitalized_names, "All")
    end
  end
  local group_suffix = table.concat(capitalized_names, "_")
  local group_name = "Special" .. group_suffix .. "Macros"
  return group_name, lang_patterns
end

--- Registers a list of functions to be executed when a specific filetype is opened.
---@param langs string|string[] The filetype(s) for which to register the macros (e.g., "lua", "python", or {"lua", "python"}).
---@param macros_table table<string, string> A table where keys are register names (e.g., "l", "q") and values are the string of keys to be pressed.
function M.single_lang(langs, macros_table)
  local group_name, lang_patterns = _normalize_lang_definitions(langs)
  vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group_name,
    pattern = lang_patterns,
    callback = function()
      for register, keys_to_press in pairs(macros_table) do
        vim.fn.setreg(register, keys_to_press)
      end
    end,
  })
end

--- Table type for defining macros for multiple language sets at once.
--- Each key is a string or a table of strings (languages), and each value is a macros table.
---@alias MacroLangs string|string[]
---@alias MacroTable table<string, string>
---@alias MacroLangsTable table<MacroLangs, MacroTable>

--- Allows defining macros for multiple language sets at once.
--- Example:
--- macros.define_table({
---   [{ "javascript", "typescript" }] = {
---     h = ":echo hello" .. macros.termcodes.CR,
---   },
---   lua = {
---     l = ":echo lua!" .. macros.termcodes.CR,
---   }
--- })
---@param tbl MacroLangsTable
function M.define_table(tbl)
  for langs, macros in pairs(tbl) do
    M.single_lang(langs, macros)
  end
end

---@class M.termcodes
---@field ESC string Esc termcode
---@field CR string Enter/Return termcode
---@field TAB string Tab termcode
---@field BS string Backspace termcode
---@field DEL string Delete termcode
---@field SPACE string Space termcode
---@field CTRL_SPACE string C-Space termcode

-- Source literals once, generate below.
local TERM_LITERALS = {
  ESC = "<Esc>",
  CR = "<CR>",
  TAB = "<Tab>",
  BS = "<BS>",
  DEL = "<Del>",
  SPACE = "<Space>",
  CTRL_SPACE = "<C-Space>",
}

-- Prefer vim.keycode() if available (Neovim ≥ 0.10); fall back to nvim_replace_termcodes.
local _keycode = vim.keycode or function(s)
  return vim.api.nvim_replace_termcodes(s, true, true, true)
end

local termcodes = {}
for k, v in pairs(TERM_LITERALS) do
  termcodes[k] = _keycode(v)
end

---@type M.termcodes
M.termcodes = termcodes

return M
