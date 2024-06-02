return {
  {
    "folke/tokyonight.nvim",
    -- opts = {
    --   transparent = true,
    --   styles = {
    --     sidebars = "transparent",
    --     floats = "transparent",
    --   },
    -- },
  },

  --  astrotheme [theme]
  --  https://github.com/AstroNvim/astrotheme
  {
    "AstroNvim/astrotheme",
    opts = {
      palette = "astrodark",
      plugins = { ["dashboard-nvim"] = true },
    },
  },

  -- nightfox [theme]
  -- https://github.com/EdenEast/nightfox.nvim
  {
    "EdenEast/nightfox.nvim",
  },

  {
    "martinsione/darkplus.nvim",
  },

  {
    "askfiy/visual_studio_code",
    priority = 100,
  },

  {
    "Mofiqul/vscode.nvim",
  },

  {
    "tiagovla/tokyodark.nvim",
    opts = {
      on_colors = function(colors)
        colors.fg_dark = "#ffffff"
      end,
    },
  },

  {
    "marko-cerovac/material.nvim",
  },

  {
    "tomasiser/vim-code-dark",
  },

  -- 'mhartington/oceanic-next'
  {
    "mhartington/oceanic-next",
  },

  -- https://neovimcraft.com/plugin/projekt0n/github-nvim-theme
  {
    "projekt0n/github-nvim-theme",
  },

  -- https://github.com/rafamadriz/neon
  {
    "rafamadriz/neon",
    config = function()
      vim.g.neon_style = "dark"
    end,
  },

  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
  },

  {
    "bluz71/vim-nightfly-colors",
    name = "nightfly",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.nightflyTerminalColors = false
      vim.g.nightflyVirtualTextColor = true
      vim.g.nightflyWinSeparator = 2
      vim.g.nightflyVirtualTextColor = true
    end,
  },

  {
    "Th3Whit3Wolf/one-nvim",
    lazy = true,
  },

  {
    "maxmx03/dracula.nvim",
    name = "dracula",
  },

  {
    "rebelot/kanagawa.nvim",
  },

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  { "sainnhe/everforest", priority = 1000 },

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load the theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "nightfly",
    },
  },
}
