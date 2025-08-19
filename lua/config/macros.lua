---@module "lib.macros"
local macros = require("lib.macros")
local ESC, CTRL_SPACE = macros.termcodes.ESC, macros.termcodes.CTRL_SPACE

local function print_macro(stmt, formatting)
  return CTRL_SPACE .. "yo" .. stmt .. '("' .. ESC .. "p i:" .. formatting .. '", ' .. ESC .. "pA;" .. ESC .. "_"
end

macros.define_table({
  rust = {
    -- log a variable with println!("variable: {:?}", variable);
    --
    -- note that treesitter must be installed in order to make this work as it
    -- uses the visual inside out selection by pressing ctrl-space
    -- l = CTRL_SPACE .. 'yoprintln!("' .. ESC .. 'p i: {:?}", ' .. ESC .. "pA;" .. ESC .. "_",
    l = print_macro("println!", " {:?}"),
  },
  lua = {
    l = print_macro("print", ""),
  },
  go = {
    l = print_macro("fmt.Println", ""),
  },
  [{ "javascript", "typescript" }] = {
    l = print_macro("console.log", ""),
  },
  [{ "c", "cpp" }] = {
    l = print_macro("printf", "%s\\n"),
  },
})
