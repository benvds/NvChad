local M = {}

M.setup_lsp = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"

  local default_servers ={"html", "cssls"}

  for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes  = 150,
      },
    }
  end

  -- elixir

  lspconfig.elixirls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/Users/benvds/.cache/elixir-ls/release/language_server.sh" }
  }

  -- typescript

  lspconfig.tsserver.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.resolved_capabilities.document_formatting = false
    end,
  }

  -- eslint

  lspconfig.eslint.setup {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      vim.api.nvim_exec(
        [[
          augroup auto_format
            autocmd!
            autocmd BufWritePre * lua vim.lsp.buf.formatting_seq_sync(nil, 3000)
          augroup end
        ]],
        false
      )
    end,
  }

end

return M
