return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "left", -- "left", "right" ou "float"
        width = 35, -- Largura da janela (aumente se achar estreita)
      },
      filesystem = {
        filtered_items = {
          visible = true, -- Mostra arquivos ocultos (.git, .env) por padrão?
          hide_dotfiles = false,
          hide_gitignored = true,
        },
        follow_current_file = {
          enabled = true, -- Quando você muda de aba, a árvore foca no arquivo automaticamente
        },
      },
    },
  },
}
