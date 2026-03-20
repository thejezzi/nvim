return {
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts table
    opts = function(_, opts)
      local prettier = require("conform.formatters.prettier")

      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = opts.formatters.prettier or {}
      opts.formatters.prettier.args = function(self, ctx)
        local ft = vim.bo[ctx.buf].filetype
        if ft == "json5" or ft == "jsonc" then
          return {
            "--parser",
            "jsonc",
            "--trailing-comma",
            "none",
            "--stdin-filepath",
            ctx.filename,
          }
        end
        return prettier.args(self, ctx)
      end

      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.jsonc = { "prettier", stop_after_first = true }
      opts.formatters_by_ft.json5 = { "prettier", stop_after_first = true }
    end,
  },
}
