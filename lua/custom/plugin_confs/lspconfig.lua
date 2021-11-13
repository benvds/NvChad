local M = {}

M.setup_lsp = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"

  local default_servers ={"html", "cssls", "tailwindcss"}

  for _, lsp in ipairs(default_servers) do
    lspconfig[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes  = 150,
      },
    }
  end

  -- emmet

  lspconfig.emmet_ls.setup {}

  -- elixir

  lspconfig.elixirls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "/Users/benvds/.cache/elixir-ls/release/language_server.sh" }
  }

  -- typescript

  lspconfig.tsserver.setup {
    init_options = require("nvim-lsp-ts-utils").init_options,
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      local ts_utils = require("nvim-lsp-ts-utils")

      ts_utils.setup {
        -- debug = false,
        -- disable_commands = false,
        enable_import_on_completion = false,

        -- -- import all
        -- import_all_timeout = 5000, -- ms
        -- -- lower numbers indicate higher priority
        -- import_all_priorities = {
        --     same_file = 1, -- add to existing import statement
        --     local_files = 2, -- git files or files with relative path markers
        --     buffer_content = 3, -- loaded buffer content
        --     buffers = 4, -- loaded buffer names
        -- },
        -- import_all_scan_buffers = 100,
        -- import_all_select_source = false,

        -- -- eslint
        -- eslint_enable_code_actions = true,
        -- eslint_enable_disable_comments = true,
        -- eslint_bin = "eslint",
        -- eslint_enable_diagnostics = false,
        -- eslint_opts = {},

        -- -- formatting
        -- enable_formatting = false,
        -- formatter = "prettier",
        -- formatter_opts = {},

        -- -- update imports on file move
        -- update_imports_on_move = false,
        -- require_confirmation_on_move = false,
        -- watch_dir = nil,

        -- -- filter diagnostics
        -- filter_out_diagnostics_by_severity = {},
        -- filter_out_diagnostics_by_code = {},

        -- -- inlay hints
        -- auto_inlay_hints = true,
        -- inlay_hints_highlight = "Comment",
      }

      -- required to fix code action ranges and filter diagnostics
      ts_utils.setup_client(client)

      -- no default maps, so you may want to define some here
      local opts = { silent = true }
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
      vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
      -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)
    end,
  }

  -- json

  lspconfig.jsonls.setup {
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
    commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
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
