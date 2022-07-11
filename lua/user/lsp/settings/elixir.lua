require 'lspconfig'.elixirls.setup {
    on_attach = require("user.lsp.handlers").on_attach,
    cmd = { "/Users/benvds/.local/share/nvim/lsp_servers/elixir-ls/release/language_server.sh" },
}
