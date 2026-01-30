return {
  -- 1. Configuração do Vesper
  {
    "datsfilipe/vesper.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vesper").setup({
        transparent = true,
        italics = { comments = true, keywords = true, functions = true },
      })

      -- --- GATILHO AUTOMÁTICO (CORREÇÃO TOTAL) ---
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local orange = "#FFC799"

          -- 1. Se for o SNACKS (Novo padrão do LazyVim)
          vim.api.nvim_set_hl(0, "SnacksIndentScope", { fg = orange, nocombine = true })

          -- 2. Se for o MINI.INDENTSCOPE (Padrão antigo)
          vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = orange, nocombine = true })

          -- 3. Se for o IBL (Indent Blankline - Escopo Ativo)
          vim.api.nvim_set_hl(0, "IblScope", { fg = orange, nocombine = true })

          -- 4. Parênteses correspondentes
          vim.api.nvim_set_hl(0, "MatchParen", { fg = orange, bold = true })
        end,
      })

      vim.cmd.colorscheme("vesper")
    end,
  },

  -- 2. Define Vesper como padrão
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "vesper" },
  },

  -- 3. Desativa outros temas
  { "folke/tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },

  -- 4. Barra de status
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.theme = "auto"
    end,
  },
}
