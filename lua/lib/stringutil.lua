local M = {}

--- Capitalizes the first letter of a string.
---@param s string
---@return string
function M.capitilize(s)
  assert(type(s) == "string", "Expected a string")
  assert(#s > 0, "String cannot be empty")
  return string.upper(string.sub(s, 1, 1)) .. string.sub(s, 2)
end

return M
