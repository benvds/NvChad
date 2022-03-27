return {
  {"tpope/vim-unimpaired", event = 'BufRead'},  -- extra mappings like [q for quickfix navigations
  {"tpope/vim-repeat",  event = 'BufModifiedSet' }, -- repeat plugin maps as a whole
  {"tpope/vim-abolish", event = "CmdlineEnter"}, -- replace variations of lower/upper case
  {"machakann/vim-sandwich", event = "BufRead"}, --, event = 'CursorMoved' } -- better add, replace, delete surrounds
  {"ntpeters/vim-better-whitespace", event = "BufRead"}, --, event = 'CursorMoved' } -- highlight trailing whitespaces
  -- comments for combined syntaxes like jsx / tsx
  {
      "JoosepAlviste/nvim-ts-context-commentstring",
      ft = { "typescript", "typescriptreact" },
      config = function()
        local present, ts_config = pcall(require, "nvim-treesitter.configs")
        if not present then
          print("nvim-treesitter.config not found")
          return
        end

        ts_config.setup {
           ensure_installed = {
              "lua",
           },
           highlight = {
              enable = true,
              use_languagetree = true,
           },
           context_commentstring = {
               enable = true
           }
        }
      end
  },
  {
    "lifepillar/vim-solarized8",
    --, event = "VimEnter"
    -- config = function()
    --   vim.api.nvim_exec(
    --       [[
    --         autocmd vimenter * ++nested colorscheme solarized8_high
    --       ]],
    --       false
    --   )
    -- end
  },
  {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  },
  {
    "windwp/nvim-ts-autotag",
    after = {"nvim-treesitter"},
    config = function()
      require('nvim-ts-autotag').setup()
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"},
    after = {"plenary.nvim", "nvim-lspconfig"},
    config = function()
      require("custom.plugin_confs.null-ls").setup()
    end,
  },
  {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "jose-elias-alvarez/null-ls.nvim"},
  },
  -- {
  --   "folke/trouble.nvim",
  --   requires = "kyazdani42/nvim-web-devicons",
  --   config = function()
  --     require("trouble").setup {}
  --     vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
  --       {silent = true, noremap = true}
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>",
  --       {silent = true, noremap = true}
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>",
  --       {silent = true, noremap = true}
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
  --       {silent = true, noremap = true}
  --     )
  --     vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
  --       {silent = true, noremap = true}
  --     )
  --     vim.api.nvim_set_keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  --       {silent = true, noremap = true}
  --     )
  --   end
  -- },
  {
    "Mofiqul/vscode.nvim",
    after = {"nvim-treesitter"},
    config = function()
      vim.g.vscode_style = "light"
      -- vim.cmd[[colorscheme vscode]]
    end,
  },
  {
    "folke/tokyonight.nvim",
    after = {"nvim-treesitter"},
  },
  {
    "EdenEast/nightfox.nvim",
    after = {"nvim-treesitter"},
    config = function()
      vim.cmd [[colorscheme dayfox]]
      -- vim.api.nvim_exec(
      --     [[
      --       autocmd vimenter * ++nested colorscheme dayfox
      --     ]],
      --     false
      -- )
    end
  },
  -- not working
  -- {
  --   "peitalin/vim-jsx-typescript",
  --   after = {"nvim-treesitter"},
  -- }
  -- {
  --   "nvim-treesitter/playground",
  --   after = {"nvim-treesitter"},
  -- }
  {
    "RRethy/nvim-treesitter-textsubjects", -- adds smart text objects
    after = {"nvim-treesitter"},
    config = function()
      -- require'nvim-treesitter.configs'.setup {
      --     textsubjects = {
      --         enable = true,
      --         keymaps = {
      --             ['.'] = 'textsubjects-smart',
      --             [';'] = 'textsubjects-container-outer',
      --         }
      --     },
      -- }
    end
  },
  {
    "phaazon/hop.nvim",
    branch = 'v1', -- optional but strongly recommended
    event = "BufRead",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup {}
    end,
  },
  { "beauwilliams/focus.nvim", config = function() require("focus").setup() end },
  { "tpope/vim-scriptease" }, -- add :Verbose map etc
  {'junegunn/fzf'},
  -- {'kevinhwang91/nvim-bqf', ft = 'qf'}
  { 'tpope/vim-fugitive' },

  -- quickfix buffer is now modifiable, :w triggers a replacement, :write writes the buffer
  { 'stefandtw/quickfix-reflector.vim' },

  { 'ggVGc/vim-fuzzysearch' },

  { 'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu' },
  { 'kosayoda/nvim-lightbulb',
    config = function()
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end
  },

  -- remove once treesitter issue has been fixed: https://github.com/nvim-treesitter/nvim-treesitter/issues/1957
  { 'elixir-editors/vim-elixir' },
}
