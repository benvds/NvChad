local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "folke/which-key.nvim"

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  -- use "lunarvim/darkplus.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-copilot"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- Telescope
  use "nvim-telescope/telescope.nvim"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  -- use "JoosepAlviste/nvim-ts-context-commentstring"

  -- Git
  use "lewis6991/gitsigns.nvim"

  use {"tpope/vim-unimpaired", event = 'BufRead'}  -- extra mappings like [q for quickfix navigations
  use {"tpope/vim-repeat",  event = 'BufModifiedSet' } -- repeat plugin maps as a whole
  use {"tpope/vim-abolish", event = "CmdlineEnter"} -- replace variations of lower/upper case
  use {"machakann/vim-sandwich", event = "BufRead"} --, event = 'CursorMoved' } -- better add, replace, delete surrounds
  use {"ntpeters/vim-better-whitespace", event = "BufRead"} --, event = 'CursorMoved' } -- highlight trailing whitespaces
  -- comments for combined syntaxes like jsx / tsx
  use {
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
  }
  use {
    "ishan9299/nvim-solarized-lua",
    --, event = "VimEnter"
    config = function()
      vim.cmd [[colorscheme solarized]]
    end
  }
  use { "haystackandroid/stellarized" }
  use { "cocopon/iceberg.vim" }
  use {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }
  use {
    "windwp/nvim-ts-autotag",
    after = {"nvim-treesitter"},
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }
  -- use {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig"},
  --   after = {"plenary.nvim", "nvim-lspconfig"},
  --   config = function()
  --     require("custom.plugin_confs.null-ls").setup()
  --   end,
  -- }
  use {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    requires = {"nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "jose-elias-alvarez/null-ls.nvim"},
  }
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
  -- }
  use {
    "Mofiqul/vscode.nvim",
    after = {"nvim-treesitter"},
    config = function()
      vim.g.vscode_style = "light"
      -- vim.cmd[[colorscheme vscode]]
    end,
  }
  use {
    "folke/tokyonight.nvim",
    after = {"nvim-treesitter"},
  }
  use {
    "EdenEast/nightfox.nvim",
    after = {"nvim-treesitter"},
    config = function()
      -- vim.cmd [[colorscheme nightfox]]
      -- vim.api.nvim_exec(
      --     [[
      --       autocmd vimenter * ++nested colorscheme dayfox
      --     ]],
      --     false
      -- )
    end
  }
  -- not working
  -- {
  --   "peitalin/vim-jsx-typescript",
  --   after = {"nvim-treesitter"},
  -- }
  -- {
  --   "nvim-treesitter/playground",
  --   after = {"nvim-treesitter"},
  -- }
  use {
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
  }
  use {
    "phaazon/hop.nvim",
    branch = 'v1', -- optional but strongly recommended
    event = "BufRead",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup {}
    end,
  }
  use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
  use { "tpope/vim-scriptease" } -- add :Verbose map etc
  use {'junegunn/fzf'}
  -- {'kevinhwang91/nvim-bqf', ft = 'qf'}
  -- { 'tpope/vim-fugitive' }

  -- quickfix buffer is now modifiable, :w triggers a replacement, :write writes the buffer
  use { 'stefandtw/quickfix-reflector.vim' }

  use { 'ggVGc/vim-fuzzysearch' }

  use {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
    config = function()
      vim.g.code_action_menu_window_border = "rounded"
      vim.g.code_action_menu_show_details = false
      vim.g.code_action_menu_show_diff = true
    end,
  }
  use { 'kosayoda/nvim-lightbulb',
    config = function()
      vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
    end
  }

  -- remove once treesitter issue has been fixed: https://github.com/nvim-treesitter/nvim-treesitter/issues/1957
  use { 'elixir-editors/vim-elixir' }

  use {
    "github/copilot.vim",
    config = function()
      vim.cmd([[
        let g:copilot_no_tab_map = v:true
        imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")
      ]])
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
