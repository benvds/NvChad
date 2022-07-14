local opts = {
    on_attach = function(client, bufnr)
        local status_ok, ts_utils = pcall(require, "nvim-lsp-ts-utils")
        if not status_ok then
            return
        end

        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        ts_utils.setup {
            -- debug = false,
            -- disable_commands = false,
            enable_import_on_completion = true,

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
            enable_formatting = false,
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
            auto_inlay_hints = false,
            -- inlay_hints_highlight = "Comment",
        }

        -- required to fix code action ranges and filter diagnostics
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        local opts = { silent = true }
        vim.api.nvim_buf_set_keymap(bufnr, "n", "tlo", ":TSLspOrganize<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "tlrf", ":TSLspRenameFile<CR>", opts)
        vim.api.nvim_buf_set_keymap(bufnr, "n", "tlia", ":TSLspImportAll<CR>", opts)
    end,
}

return opts
