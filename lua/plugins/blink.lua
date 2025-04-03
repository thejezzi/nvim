return {
  "saghen/blink.cmp",
  dependencies = {
    "saghen/blink.compat",
    "allaman/emoji.nvim",
    "hrsh7th/cmp-calc",
    "chrisgrieser/cmp-nerdfont",
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
      default = { "emoji", "lazydev", "calc", "path", "snippets", "nerdfont" },
      per_filetype = {
        codecompanion = { "codecompanion" },
      },
      providers = {
        nerdfont = {
          name = "nerdfont",
          module = "blink.compat.source",
        },
        calc = {
          name = "calc",
          module = "blink.compat.source",
        },
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
