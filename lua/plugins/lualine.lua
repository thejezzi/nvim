return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      local icons = require("lazyvim.config").icons

      opts.sections.lualine_c = {
        Util.lualine.root_dir(),
        {
          "diagnostics",
          symbols = {
            error = icons.diagnostics.Error,
            warn = icons.diagnostics.Warn,
            info = icons.diagnostics.Info,
            hint = icons.diagnostics.Hint,
          },
        },
        {
          "filetype",
          icon_only = true,
          separator = "",
          padding = { left = 1, right = 0 },
          on_click = function()
            require("lib").change_filetype_window()
          end,
        },
        { Util.lualine.pretty_path() },
        {
          function()
            local filetype = vim.bo.filetype
            if filetype == "" then
              return "🚫" -- Platzhalter-Icon, wenn kein Dateityp vorhanden ist
            end
            return ""
          end,
          on_click = function()
            require("lib").change_filetype_window()
          end,
        },
      }
    end,
  },
}
