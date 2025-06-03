---@diagnostic disable: missing-fields
---@return snacks.Config
local buildOpts = function()
  ---@type snacks.Config
  local default = {}

  if vim.fn.executable("git-delta") then
    default["lazygit"] = {
      config = {
        git = {
          paging = {
            colorArg = "always",
            pager = "delta --dark --paging=never --line-numbers --hyperlinks"
              .. ' --hyperlinks-file-link-format="lazygit-edit://{path}:{line}"',
          },
        },
      },
    }
  end

  return default
end

return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = buildOpts(),
}
