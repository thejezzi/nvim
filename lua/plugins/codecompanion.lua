local wk = require("which-key")

wk.add({
  { "<leader>ia", "<Cmd>CodeCompanionActions<CR>", desc = "Open action palette" },
  { "<leader>id", "<Cmd>CodeCompanionCmd<CR>", desc = "Generate command", mode = { "n", "v" } },
  { "<leader>ij", "<Cmd>CodeCompanion<CR>", desc = "Inline assistant" },
  { "<leader>ii", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat buffer" },
  { "<leader>ia", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add to chat buffer", mode = "v" },
})

local vector_code = {
  "Davidyz/VectorCode",
  version = "*", -- optional, depending on whether you're on nightly or release
  build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
  dependencies = { "nvim-lua/plenary.nvim" },
}

local mcp_hub = {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  },
  -- comment the following line to ensure hub will be ready at the earliest
  -- cmd = "MCPHub", -- lazy load by default
  build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
  -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
  opts = {},
}

---extensions builds the extensions table that need to be loaded as plugins in
---order to use them in codecompanion
---@return table
local function extensions()
  local resulting = {}
  table.insert(resulting, 1, mcp_hub)

  if vim.fn.executable("vectorcode") == 1 then
    table.insert(resulting, 1, vector_code)
  end

  return resulting
end

---Builds the plugin definition for codecompanion
---@return table plugin_def
local function build_codecompanion()
  local plugin_def = {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "j-hui/fidget.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      extensions = {
        vectorcode = {
          opts = {
            add_tool = true,
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface ("telescope" or "snacks" or "fzf-lua" or "default")
            picker = "telescope",
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to active chat's adapter)
              adapter = nil, -- e.g "copilot"
              ---Model for generating titles (defaults to active chat's model)
              model = nil, -- e.g "gpt-4o"
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,
          },
        },
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show mcp tool results in chat
            make_vars = true, -- Convert resources to #variables
            make_slash_commands = true, -- Add prompts as /slash commands
          },
        },
      },
      log_level = "DEBUG",
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "phi4",
              },
              num_ctx = {
                default = 20000,
              },
            },
          })
        end,
        gemini = function()
          return require("codecompanion.adapters").extend("gemini", {
            env = {
              api_key = "cmd: gpg --batch --quiet --decrypt ~/k.txt.gpg",
            },
            schema = {
              model = {
                default = "gemini-2.0-flash",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "gemini",
          slash_commands = {
            ["git_files"] = {
              description = "Add content of all Git-tracked files",
              callback = function(chat)
                local handle = io.popen("git ls-files")
                if handle then
                  local files = handle:read("*a")
                  handle:close()
                  if files == "" then
                    vim.notify("No git files found", vim.log.levels.INFO, { title = "CodeCompanion" })
                    return
                  end

                  -- Split by newlines
                  for file in files:gmatch("[^\r\n]+") do
                    -- Read each file content
                    local f = io.open(file, "r")
                    if f then
                      local content = f:read("*a")
                      f:close()
                      -- Add each file as a separate reference
                      chat:add_reference({
                        role = "user",
                        name = file,
                        content = content,
                      }, "git", file)
                    end
                  end
                else
                  vim.notify("Failed to run git ls-files", vim.log.levels.ERROR, { title = "CodeCompanion" })
                end
              end,
              opts = { contains_code = true },
            },
          },
        },
        inline = {
          adapter = "gemini",
        },
        cmd = {
          adapter = "gemini",
        },
      },
    },
  }

  return plugin_def
end

return {
  extensions(),
  build_codecompanion(),
}
