vim.diagnostic.config({
  float = { border = "rounded" },
})

-- -- disable copilot by default
-- vim.cmd("Copilot disable")

vim.filetype.add({
  pattern = {
    [".*.jenkinsfile"] = "groovy",
    ["Jenkinsfile..*"] = "groovy",
    ["Jenkinsfile"] = "groovy",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "groovy" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.expandtab = true
  end,
})
