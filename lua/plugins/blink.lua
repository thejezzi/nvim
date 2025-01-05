return {
  "saghen/blink.cmp",
  dependencies = {
    "allaman/emoji.nvim",
    "saghen/blink.compat",
  },
  opts = {
    completion = {
      -- menu = {
      --   draw = {
      --     columns = {
      --       { "label", "label_description", gap = 1 },
      --       { "kind_icon", "kind" },
      --     },
      --   },
      -- },
    },
    keymap = {
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    sources = {
      default = { "emoji", "lazydev" },
      providers = {
        emoji = {
          name = "emoji",
          module = "blink.compat.source",
          -- overwrite kind of suggestion
          transform_items = function(_, items)
            local kind = require("blink.cmp.types").CompletionItemKind.Text
            for i = 1, #items do
              items[i].kind = kind
            end
            return items
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100, -- show at a higher priority than lsp
        },
      },
    },
  },
}
