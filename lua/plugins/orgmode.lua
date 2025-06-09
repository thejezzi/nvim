local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  opts = {
    org_agenda_files = "~/orgfiles/**/*",
    org_default_notes_file = "~/orgfiles/refile.org",
    -- notifications = {
    --   enabled = true,
    --   cron_enabled = true,
    --   reminder_time = 10,
    --   notifier = function(tasks)
    --     local lines = {}
    --     for _, task in ipairs(tasks) do
    --       table.insert(lines, string.format("🔔 %s: %s", task.humanized_duration, task.title))
    --     end
    --     -- Hier setzen wir title = "Orgmode"
    --     vim.notify(lines, vim.log.levels.INFO, { title = "Orgmode" })
    --   end,
    --   cron_notifier = function(tasks)
    --     -- ggf. dieselbe Logik für cron-basierte Erinnerungen
    --     for _, task in ipairs(tasks) do
    --       local title = string.format("🔔 %s: %s", task.humanized_duration, task.title)
    --       vim.notify(title, vim.log.levels.INFO, { title = "Orgmode (Cron)" })
    --     end
    --   end,
    -- },
    ui = {
      menu = {
        handler = function(data)
          -- your handler here, for example:
          local options = {}
          local options_by_label = {}

          for _, item in ipairs(data.items) do
            -- Only MenuOption has `key`
            -- Also we don't need `Quit` option because we can close the menu with ESC
            if item.key and item.label:lower() ~= "quit" then
              table.insert(options, item.label)
              options_by_label[item.label] = item
            end
          end

          local handler = function(choice)
            if not choice then
              return
            end

            local option = options_by_label[choice]
            if option.action then
              option.action()
            end
          end

          vim.ui.select(options, {
            prompt = data.prompt,
          }, handler)
        end,
      },
    },
  },
}
