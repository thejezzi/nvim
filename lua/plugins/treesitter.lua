return {
  {
    "amber-lang/amber-vim",
    ft = "amber",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      local function register_amber()
        local ok, parsers = pcall(require, "nvim-treesitter.parsers")
        if not ok then
          return
        end

        parsers.amber = {
          install_info = {
            url = "https://github.com/amber-lang/tree-sitter-amber",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "amber",
        }
      end

      vim.filetype.add({
        extension = {
          ab = "amber",
        },
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        group = vim.api.nvim_create_augroup("amber_treesitter_parser", { clear = true }),
        callback = register_amber,
        desc = "Register custom Amber Tree-sitter parser",
      })

      register_amber()
    end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if type(opts.ensure_installed) == "table" and not vim.tbl_contains(opts.ensure_installed, "amber") then
        table.insert(opts.ensure_installed, "amber")
      end

      return opts
    end,
  },
}
