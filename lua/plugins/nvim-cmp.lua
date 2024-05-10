return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
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
  end,
}
