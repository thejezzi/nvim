--- @module "arresto"

local dir = vim.fn.expand("~/code/arresto.nvim")
if vim.fn.isdirectory(dir) == 0 then
  return {}
end

return {
  "thejezzi/arresto.nvim",
  dir = dir,
  ---@type ArrestoConfig
  opts = {},
}
