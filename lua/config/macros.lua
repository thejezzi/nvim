---@module "lib.macros"
local macros = require("lib.macros")
local ESC, CTRL_SPACE = macros.termcodes.ESC, macros.termcodes.CTRL_SPACE

macros.define_table({
  rust = {
    -- log a variable with println!("variable: {:?}", variable);
    --
    -- note that treesitter must be installed in order to make this work as it
    -- uses the visual inside out selection by pressing ctrl-space
    l = CTRL_SPACE .. 'yoprintln!("' .. ESC .. 'p i: {:?}", ' .. ESC .. "pA;" .. ESC .. "_",
  },
})
