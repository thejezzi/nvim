local function mason_root()
  return vim.fn.stdpath("data") .. "/mason"
end

local function existing_analyzers()
  local analyzer_paths = {
    mason_root() .. "/share/sonarlint-analyzers/sonargo.jar",
    mason_root() .. "/share/sonarlint-analyzers/sonarcfamily.jar",
    mason_root() .. "/share/sonarlint-analyzers/sonarpython.jar",
    mason_root() .. "/share/sonarlint-analyzers/sonarjava.jar",
  }

  local installed = {}
  for _, path in ipairs(analyzer_paths) do
    if vim.loop.fs_stat(path) then
      table.insert(installed, path)
    end
  end

  return installed
end

local function mason_bin(name)
  return mason_root() .. "/bin/" .. name
end

local function sonarqube_settings()
  local server_url = vim.fn.getenv("SONAR_SERVER_URL")
  local connection_id = vim.fn.getenv("SONAR_CONNECTION_ID")
  local project_key = vim.fn.getenv("SONAR_PROJECT_KEY")
  local token = vim.fn.getenv("SONAR_TOKEN")

  if server_url == vim.NIL or server_url == "" then
    return nil, nil
  end

  if connection_id == vim.NIL or connection_id == "" then
    connection_id = "sonarqube"
  end

  if token == vim.NIL or token == "" then
    return nil, nil
  end

  local settings = {
    sonarlint = {
      connectedMode = {
        connections = {
          sonarqube = {
            {
              connectionId = connection_id,
              serverUrl = server_url,
              disableNotifications = false,
            },
          },
        },
      },
    },
  }

  local before_init = nil
  if not (project_key == vim.NIL or project_key == "") then
    before_init = function(_, config)
      config.settings.sonarlint.connectedMode.project = {
        connectionId = connection_id,
        projectKey = project_key,
      }
    end
  end

  return settings, before_init
end

return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  enabled = false,
  config = function()
    if vim.loop.os_uname().sysname ~= "Darwin" then
      return
    end

    local cmd = { mason_bin("sonarlint-language-server"), "-stdio" }
    local analyzers = existing_analyzers()
    if #analyzers > 0 then
      vim.list_extend(cmd, { "-analyzers" })
      vim.list_extend(cmd, analyzers)
    end

    local settings, before_init = sonarqube_settings()

    require("sonarlint").setup({
      server = {
        cmd = cmd,
        settings = settings,
        before_init = before_init,
      },
      filetypes = { "go", "cpp" },
      connected = settings and {
        get_credentials = function()
          return vim.fn.getenv("SONAR_TOKEN")
        end,
      } or nil,
    })
  end,
}
