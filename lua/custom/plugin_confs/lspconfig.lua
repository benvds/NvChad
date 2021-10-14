local present1, nvim_lsp = pcall(require, "lspconfig")
local overrides = require("core.hooks").createOverrides "lsp"

if not present1 then
   return
end

local function on_attach_default(_, bufnr)
   local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
   end
   local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
   end

   -- Enable completion triggered by <c-x><c-o>
   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   local opts = {
     noremap = true,
     silent = true,
   }
   popup_opts = "{border=\"rounded\",focusable=false,max_width=80}"

   -- See `:help vim.lsp.*` for documentation on any of the below functions
   buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
   buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
   buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
   buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
   buf_set_keymap("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
   buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
   buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
   buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
   buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
   buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
   buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
   buf_set_keymap("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
   buf_set_keymap("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts="..popup_opts.."})<CR>", opts)
   buf_set_keymap("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts="..popup_opts.."})<CR>", opts)
   buf_set_keymap("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
   buf_set_keymap("v", "<space>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

local on_attach_typescript = function(client, bufnr)
  -- disable tsserver formatting if you plan on formatting via null-ls
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false

  local ts_utils = require("nvim-lsp-ts-utils")

  -- defaults
  ts_utils.setup {
      debug = false,
      disable_commands = false,
      enable_import_on_completion = false,
      -- import all
      import_all_timeout = 5000, -- ms
      import_all_priorities = {
          buffers = 4, -- loaded buffer names
          buffer_content = 3, -- loaded buffer content
          local_files = 2, -- git files or files with relative path markers
          same_file = 1 -- add to existing import statement
      },
      import_all_scan_buffers = 100,
      import_all_select_source = false,
      -- eslint
      eslint_enable_code_actions = true,
      eslint_enable_disable_comments = true,
      eslint_bin = "eslint_d",
      eslint_enable_config_fallback = nil,
      eslint_enable_diagnostics = true,
      -- eslint_opts = {},
      -- formatting
      enable_formatting = true,
      formatter = "eslint_d",
      formatter_config_fallback = nil,
      -- formatter_opts = {},

      -- parentheses completion
      complete_parens = true,
      signature_help_in_parens = true,
      -- update imports on file move
      update_imports_on_move = false,
      require_confirmation_on_move = false,
      watch_dir = nil,
      -- filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {}
  }

  -- required to fix code action ranges and filter diagnostics
  ts_utils.setup_client(client)

  -- no default maps, so you may want to define some here
  -- local opts = { silent = true }
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", opts)
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, "n", "gq", ":TSLspFixCurrent<CR>", {silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rf", ":TSLspRenameFile<CR>", {silent = true})
  vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ia", ":TSLspImportAll<CR>", {silent = true}) -- vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", opts)

  vim.api.nvim_exec(
    [[
      augroup auto_format
        autocmd!
        autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 3000)
      augroup end
    ]],
    false
  )
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

local servers = require("core.utils").load_config().plugins.options.lspconfig.servers

for _, lsp in ipairs(servers) do
  if (lsp == "tsserver") then
   require("null-ls").config({ debug = false })
   nvim_lsp["null-ls"].setup { debug = false }

   nvim_lsp[lsp].setup {
      on_attach = function(client, bufnr)
        on_attach_default(client, bufnr)
        on_attach_typescript(client, bufnr)
      end,
      capabilities = capabilities,
      flags = {
         debounce_text_changes = 150,
      },
   }
  else
   nvim_lsp[lsp].setup {
      on_attach = on_attach_default,
      capabilities = capabilities,
      -- root_dir = vim.loop.cwd,
      flags = {
         debounce_text_changes = 150,
      },
   }
  end
end

-- require("anyfile").setup_luaLsp(on_attach, capabilities) -- this will be removed soon after the custom hooks PR

-- replace the default lsp diagnostic symbols
local function lspSymbol(name, icon)
   vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefault" .. name })
end

lspSymbol("Error", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")
lspSymbol("Warning", "")

local lsp_publish_diagnostics_options = overrides.get("publish_diagnostics", {
   virtual_text = {
      prefix = "",
      spacing = 0,
   },
   signs = true,
   underline = true,
   update_in_insert = false, -- update diagnostics insert mode
})
local pop_opts = { border = "rounded", max_width = 80 }

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
   vim.lsp.diagnostic.on_publish_diagnostics,
   lsp_publish_diagnostics_options
)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = "single",
})

-- suppress error messages from lang servers
vim.notify = function(msg, log_level, _opts)
   if msg:match "exit code" then
      return
   end
   if log_level == vim.log.levels.ERROR then
      vim.api.nvim_err_writeln(msg)
   else
      vim.api.nvim_echo({ { msg } }, true, {})
   end
end
