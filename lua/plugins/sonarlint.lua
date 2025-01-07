local lspconfig = require("lspconfig")
local wk = require("which-key")

return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  enabled = false,
  config = function()
    require("sonarlint").setup({
      server = {
        cmd = {
          "sonarlint-language-server",
          -- Ensure that sonarlint-language-server uses stdio channel
          "-stdio",
          "-analyzers",
          -- paths to the analyzers you need, using those for python and java in this example
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
        },
      },
      root_dir = lspconfig.util.root_pattern(".git", "sonar-project.properties"),
      settings = {
        sonarlint = {
          connection = {
            serverUrl = "https://sonarqube.reisedirektanbindung.check24.de",
            token = "squ_d1ec62b38ea370e1b23256aa39b7aa902d8d871c", -- Sicheren Token einsetzen
          },
          projectKey = "searchbroker", -- Projekt definieren
        },
      },
      filetypes = {
        "go",
        "cpp",
      },
    })
  end,
}
