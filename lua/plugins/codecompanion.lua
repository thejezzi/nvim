local wk = require("which-key")

wk.add({
  { "<leader>ia", "<Cmd>CodeCompanionActions<CR>", desc = "Open action palette" },
  { "<leader>id", "<Cmd>CodeCompanionCmd<CR>", desc = "Generate command" },
  { "<leader>ij", "<Cmd>CodeCompanion<CR>", desc = "Inline assistant" },
  { "<leader>ii", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle chat buffer" },
  { "<leader>ia", "<Cmd>CodeCompanionChat Add<CR>", desc = "Add to chat buffer", mode = "v" },
})

return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
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
        adapter = "ollama",
      },
      inline = {
        adapter = "ollama",
      },
      cmd = {
        adapter = "ollama",
      },
    },
  },
}
