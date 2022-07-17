local util = require("lspconfig/util")
local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.credo.with({
            extra_filetypes = { "eelixir", "heex" },
            root_dir = util.root_pattern(".credo.exs", "mix.exs", ".env"),
        })
    },
})
