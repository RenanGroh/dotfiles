return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gdscript = {
        name = "godot",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 6005), -- lenguage port
      },
    },
  },
}
