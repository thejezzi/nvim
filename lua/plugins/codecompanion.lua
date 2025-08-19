---@module "codecompanion"
---@module "lazy"

local wk = require("which-key")

---Adds the content of all Git-tracked files to the chat buffer.
---@param chat CodeCompanion.Chat The chat buffer to add the files to.
local function git_files_callback(chat)
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
end

---Builds the adapters configuration for CodeCompanion.
---Each adapter is defined as a function that returns an extended adapter configuration.
---@return table<string, function> The adapters configuration table.
local function get_adapters()
  return {
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
          api_key = "cmd: gpg --batch --quiet --decrypt ~/gemini.gpg",
        },
        schema = {
          model = {
            default = "gemini-2.5-flash",
          },
        },
      })
    end,
    tavily = function()
      return require("codecompanion.adapters").extend("tavily", {
        env = {
          api_key = "cmd: gpg --batch --quiet --decrypt ~/tavily.gpg",
        },
      })
    end,
  }
end

---Builds the strategies configuration for CodeCompanion.
---It determines the default adapter based on the operating system.
---@return table<string, table> The strategies configuration table.
local function get_strategies()
  local is_mac = vim.uv.os_uname().sysname == "Darwin"
  local default_adapter = is_mac and "copilot" or "gemini"
  return {
    chat = {
      adapter = default_adapter,
      -- custom git_files slash command adds all files tracked by git to the chat buffer and
      -- is useful if the project is not really that big or the context is big enough.
      slash_commands = {
        ["git_files"] = {
          description = "Add content of all Git-tracked files",
          callback = git_files_callback,
          opts = { contains_code = true },
        },
      },
    },
    inline = {
      adapter = default_adapter,
    },
    cmd = {
      adapter = default_adapter,
    },
  }
end

---Builds the extensions configuration for CodeCompanion.
---Conditionally adds the vectorcode extension if it's executable.
---@param vectorcode_enabled boolean Whether the vectorcode executable is available.
---@return table<string, table> The extensions configuration table.
local function get_extensions_config(vectorcode_enabled)
  local config = {
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
  }

  -- If the vectorcode extension and vectorcode is installed we can use it in the chat buffer as
  -- well.
  if vectorcode_enabled then
    config.vectorcode = {
      opts = {
        add_tool = true,
      },
    }
  end
  return config
end

-- default opts table which includes the history extension and gemini adapters as well as the
-- mcp_hub def. The history extension ensures that chats that stopped working or are needed
-- later can still be reloaded into the chat buffer.
-- The MCP Protocol gives us the ability to let the llm do anything we want and the mcp hub is
-- a nice way to install mcp servers from the hub without doing the configuration ourselves.
---Gathers all the configurations and returns the final options table for codecompanion.nvim.
---@return table The complete options table for `codecompanion.nvim`.
local function get_opts()
  local vectorcode_enabled = vim.fn.executable("vectorcode") == 1
  return {
    log_level = "DEBUG",
    adapters = get_adapters(),
    strategies = get_strategies(),
    extensions = get_extensions_config(vectorcode_enabled),
  }
end

return {
  {
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
  },
  {
    "Davidyz/VectorCode",
    cond = vim.fn.executable("vectorcode") == 1,
    version = "*", -- optional, depending on whether you're on nightly or release
    build = "pipx upgrade vectorcode", -- optional but recommended. This keeps your CLI up-to-date.
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    --- TODO: This fork is just a temporary fix for tool calling with gemini and should be replaced
    --- with the original repository once the PR #1628 is merged
    "olimorris/codecompanion.nvim",
    dependencies = {
      "ravitemer/codecompanion-history.nvim",
      "j-hui/fidget.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.diff",
    },
    opts = get_opts,
    ---@param opts table The options table returned by `get_opts`.
    config = function(_, opts)
      require("codecompanion").setup(opts)
      wk.add({
        { "<leader>i", group = "CodeCompanion", icon = "󱢮" },
        { "<leader>ia", "<Cmd>CodeCompanionActions<CR>", desc = "Open action palette", mode = "n" },
        { "<leader>id", "<Cmd>CodeCompanionCmd<CR>", desc = "Generate command", mode = { "n", "v" } },
        { "<leader>ij", "<Cmd>CodeCompanion<CR>", desc = "Inline assistant", icon = "󱌿" },
        { "<leader>ii", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat buffer", icon = "󰨙" },
        { "<leader>ib", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add to chat buffer", mode = "v" },
        {
          "<leader>ia",
          function()
            -- Get visual selection range
            local mode = vim.fn.mode()
            if mode ~= "v" and mode ~= "V" and mode ~= "\22" then
              vim.notify("No visual selection detected", vim.log.levels.WARN)
              return
            end
            vim.ui.input({ prompt = "Ask CodeCompanion about selection: " }, function(input)
              if input and input ~= "" then
                -- Escape single quotes in input for command
                local prompt = input:gsub("'", "''")
                -- Run the command on the visual selection
                vim.cmd("'<,'>CodeCompanion " .. prompt)
              end
            end)
          end,
          desc = "Ask CodeCompanion about selection",
          mode = "v",
        },
      })
    end,
  },
}
