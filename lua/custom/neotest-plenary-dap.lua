-- lua/custom/neotest-plenary-dap.lua

return {
  name = "Custom Plenary DAP Adapter",
  new = function(config)
    -- 1. Lade und erstelle die originale Adapter-Instanz mit der korrekten Konfiguration.
    local original_adapter = require("neotest-plenary.adapter")(config)

    -- 2. Erstelle eine neue Tabelle, die NUR unsere Änderungen enthält.
    local dap_adapter = {}

    -- Unsere überschriebene 'run'-Funktion
    dap_adapter.run = function(spec, strategy)
      if strategy ~= "dap" then
        -- Wenn die Strategie nicht 'dap' ist, rufe die 'run'-Funktion des Originals auf.
        return original_adapter.run(spec, strategy)
      end

      -- Ansonsten, führe unsere DAP-Logik aus.
      local position = spec:get_position()
      if not position then
        vim.notify("Neotest konnte die Testposition nicht finden.", vim.log.levels.ERROR)
        return
      end
      local test_path = position.path
      local test_name = position.display_name

      require("dap").run({
        type = "nlua",
        request = "launch",
        name = "Neotest Plenary Debug",
        program = {
          lua = "plenary.test_file",
          args = { test_path, { name = test_name } },
        },
        cwd = vim.fn.getcwd(),
        stopOnEntry = true,
      })
    end

    -- 3. [[ DER ENTSCHEIDENDE SCHRITT ]]
    -- Setze die Metatable. Wenn ein Feld (z.B. 'root') in 'dap_adapter' nicht gefunden wird,
    -- sucht Lua automatisch im 'original_adapter' danach.
    setmetatable(dap_adapter, { __index = original_adapter })

    return dap_adapter
  end,
}
