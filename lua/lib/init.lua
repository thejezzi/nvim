local M = {}

M.change_filetype_window = function()
  local actions = require("telescope.actions")
  local actions_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local sorters = require("telescope.sorters")

  local function enter(prompt_bufnr)
    local selected = actions_state.get_selected_entry()
    actions.close(prompt_bufnr)

    vim.cmd("setfiletype " .. selected[1])

    local lsp = vim.lsp.get_clients()
    if next(lsp) == nil then
      return
    end

    vim.cmd([[LspRestart<cr>]])
  end

  local filetypes_list = vim.fn.getcompletion("", "filetype")

  local opts = {
    finder = finders.new_table(filetypes_list),
    sorter = sorters.get_generic_fuzzy_sorter({}),

    attach_mappings = function(_, map)
      map("i", "<CR>", enter)
      return true
    end,
  }

  local filetypes = pickers.new(opts, {})

  filetypes:find()
end

--- Toggle buffer semantic token highlighting for all language servers that support it
--@param bufnr? number the buffer to toggle the clients on
function M.toggle_buffer_semantic_tokens(bufnr)
  bufnr = bufnr or 0
  vim.b[bufnr].semantic_tokens_enabled = not vim.b[bufnr].semantic_tokens_enabled
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b[bufnr].semantic_tokens_enabled and "start" or "stop"](bufnr, client.id)
      vim.notify(string.format("Buffer lsp semantic highlighting %s" + bool2str(vim.b[bufnr].semantic_tokens_enabled)))
    end
  end
end

function bool2str(bool)
  return bool and "enabled" or "disabled"
end

return M
