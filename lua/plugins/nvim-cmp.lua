return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-calc",
    "https://codeberg.org/FelipeLema/cmp-async-path",
    "chrisgrieser/cmp-nerdfont",
    -- "kristijanhusak/vim-dadbod-completion",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    -- add some cmp sources that are quite useful
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, { name = "calc" })
    table.insert(opts.sources, { name = "async_path" })
    table.insert(opts.sources, { name = "nerdfont" })
    -- table.insert(opts.sources, { name = "vim-dadbod-completion" })

    -- prevent the cmp windows (dropdown and documentation) from becoming to big
    -- or too small when using splits or a small screen size
    opts.formatting.format = function(_, item)
      local icons = require("lazyvim.config").icons.kinds
      if icons[item.kind] then
        item.kind = icons[item.kind] .. item.kind
      end

      -- shorten the menu text to 30 as it is too long
      -- especially in rust
      if item.menu and string.len(item.menu) > 30 then
        item.menu = string.sub(item.menu, 1, 30)
      end

      -- return the item if the width is greater than 100
      if vim.api.nvim_win_get_width(0) > 100 then
        return item
      end

      -- shorten the menu text to 15 as it is too long
      -- for a small window
      if item.menu and string.len(item.menu) > 15 then
        item.menu = string.sub(item.menu, 1, 15)
      end

      if item.abbr and string.len(item.abbr) > 22 then
        item.abbr = string.sub(item.abbr, 1, 22)
      end

      if item.kind and string.len(item.kind) > 20 then
        item.kind = string.sub(item.kind, 1, 20)
      end

      return item
    end

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local cmp = require("cmp")

    -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
    --   ["<Tab>"] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_next_item()
    --       -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
    --       -- this way you will only jump inside the snippet region
    --     elseif has_words_before() then
    --       cmp.complete()
    --     else
    --       fallback()
    --     end
    --   end, { "i", "s" }),
    --   ["<S-Tab>"] = cmp.mapping(function(fallback)
    --     if cmp.visible() then
    --       cmp.select_prev_item()
    --     else
    --       fallback()
    --     end
    --   end, { "i", "s" }),
    -- })

    opts.completion = {
      -- autocomplete = false,
      completeopt = "menu,menuone,noinsert",
    }
    local cmp_window = require("cmp.config.window")
    opts.window = {
      completion = cmp_window.bordered(),
      documentation = cmp_window.bordered(),
    }

    cmp.setup.filetype({ "sql" }, {
      sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
      },
    })
  end,
}
