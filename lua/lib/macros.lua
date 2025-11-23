local stringutil = require("lib.stringutil")

---@class MacroContext
---@field buf number Current buffer handle
---@field win number Current window handle
---@field ft string Filetype of the current buffer
---@field file string Full path to the current file
---@field filename string Name of the current file
---@field dir string Current working directory

--- Table type for defining macros for multiple language sets at once.
--- Each key is a string or a table of strings (languages), and each value is a macros table.
---@alias MacroLangs string|string[]
---@alias MacroTable table<string, string|MacroFunction>
---@alias MacroLangsTable table<MacroLangs, MacroTable>
---@alias MacroFunction fun(ctx: MacroContext) : string

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

  if lang_patterns[1] == "*" then
    return "SpecialAllMacros", { "*" }
  end

  local capitalized_names = {}
  for _, lang_name in ipairs(lang_patterns) do
    table.insert(capitalized_names, stringutil.capitilize(lang_name))
  end
  local group_suffix = table.concat(capitalized_names, "_")
  local group_name = "Special" .. group_suffix .. "Macros"
  return group_name, lang_patterns
end

--- Builds a context table containing various Neovim and file-related information.
--- This table can be used to pass environment details to other functions.
---@return MacroContext # A table containing context information.
local function _build_context()
  return {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
    ft = vim.bo.filetype,
    file = vim.fn.expand("%:p"),
    filename = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":t"),
    dir = vim.fn.getcwd(),
  }
end

---Evaluates the value of a macro, which can be a string or a function.
---@param register string The register name where the macro is stored (e.g., "l", "q").
---@param thismacro string|MacroFunction The value of the macro, which can be a string or a function.
---@return boolean, string Either ok and returns the macro or false if somehting went wrong
local function _evaluate_macro_value(register, thismacro)
  local ctx = _build_context()
  if type(thismacro) == "string" then
    return true, thismacro
  end
  assert(type(thismacro) == "function", "Expected the macro to be a function")
  local ok, res = pcall(thismacro, ctx)
  if not ok then
    vim.notify(
      "macro function error for @" .. tostring(register) .. ": " .. tostring(res),
      vim.log.levels.ERROR,
      { title = "Macros" }
    )
    return false, ""
  end
  return true, res
end

--- Registers a list of functions to be executed when a specific filetype is opened.
---@param langs string|string[] The filetype(s) for which to register the macros (e.g., "lua", "python", or {"lua", "python"}).
---@param macros_table MacroTable A table where keys are register names (e.g., "l", "q") and values are the string of keys to be pressed.
function M.single_lang(langs, macros_table)
  local group_name, lang_patterns = _normalize_lang_definitions(langs)
  vim.api.nvim_create_augroup(group_name, { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group_name,
    pattern = lang_patterns,
    callback = function()
      for register, val in pairs(macros_table) do
        local ok, final_macro = _evaluate_macro_value(register, val)
        if ok and type(final_macro) == "string" then
          vim.fn.setreg(register, final_macro)
        end
      end
    end,
  })
end

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
