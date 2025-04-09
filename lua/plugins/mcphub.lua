return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for Job and HTTP requests
  },
  -- comment the following line to ensure hub will be ready at the earliest
  cmd = "MCPHub", -- lazy load by default
  build = "npm install -g mcp-hub@latest", -- Installs required mcp-hub npm module
  -- uncomment this if you don't want mcp-hub to be available globally or can't use -g
  -- build = "bundled_build.lua",  -- Use this and set use_bundled_binary = true in opts  (see Advanced configuration)
  config = function()
    require("mcphub").setup()
  end,
  opts = {
    extensions = {
      codecompanion = {
        -- Show the mcp tool result in the chat buffer
        show_result_in_chat = true,
        -- Make chat #variables from MCP server resources
        make_vars = true,
        -- Create slash commands for prompts
        make_slash_commands = true,
      },
    },
  },
}
