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
  -- use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "folke/which-key.nvim"

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
  use {
    'RRethy/nvim-treesitter-textsubjects',
    after = "nvim-treesitter",
    config = function()
      require('nvim-treesitter.configs').setup {
        textsubjects = {
          enable = true,
          prev_selection = ',', -- (Optional) keymap to select the previous selection
          keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
            ['i;'] = 'textsubjects-container-inner',
          },
        },
      }
    end
  }
  -- Git
  use "lewis6991/gitsigns.nvim"
  use "tpope/vim-fugitive"

  use { "tpope/vim-unimpaired", event = 'BufRead' } -- extra mappings like [q for quickfix navigations
  use { "tpope/vim-repeat", event = 'BufModifiedSet' } -- repeat plugin maps as a whole
  use { "tpope/vim-abolish", event = "CmdlineEnter" } -- replace variations of lower/upper case
  use { "machakann/vim-sandwich", event = "BufRead" } --, event = 'CursorMoved' } -- better add, replace, delete surrounds
  use { "ntpeters/vim-better-whitespace", event = "BufRead" } --, event = 'CursorMoved' } -- highlight trailing whitespaces
  -- comments for combined syntaxes like jsx / tsx
  use {
    "JoosepAlviste/nvim-ts-context-commentstring",
    config = function()
      local present, ts_config = pcall(require, "nvim-treesitter.configs")
      if not present then
        print("nvim-treesitter.config not found")
        return
      end

      require 'nvim-treesitter.configs'.setup {
        context_commentstring = {
          enable = true,
          enable_autocmd = false,
        }
      }

      require('Comment').setup {
        pre_hook = function(ctx)
          local U = require 'Comment.utils'

          local location = nil
          if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
          end

          return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
          }
        end,
      }

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
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }
  use {
    "windwp/nvim-ts-autotag",
    after = { "nvim-treesitter" },
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }
  use {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "jose-elias-alvarez/null-ls.nvim" },
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

  -- coloschemes

  use {
    "ishan9299/nvim-solarized-lua",
    event = "VimEnter",
    config = function()
      vim.cmd [[colorscheme solarized]]
    end
  }
  use { "haystackandroid/stellarized" }
  use { "cocopon/iceberg.vim" }
  use {
    "Mofiqul/vscode.nvim",
    after = { "nvim-treesitter" },
  }
  use {
    "folke/tokyonight.nvim",
    after = { "nvim-treesitter" },
    config = function()
      vim.g.tokyonight_day_brightness = 0.1
      vim.g.tokyonight_style = "storm"
    end,
  }
  use {
    "EdenEast/nightfox.nvim",
    after = { "nvim-treesitter" },
  }

  use {
    "rlane/pounce.nvim",
    event = "BufRead",
    config = function()
      -- require("pounce").setup({})
      vim.api.nvim_set_keymap("n", "s", "<cmd>Pounce<CR>", {})
      vim.api.nvim_set_keymap("n", "S", "<cmd>PounceRepeat<CR>", {})
      vim.api.nvim_set_keymap("v", "s", "<cmd>Pounce<CR>", {})
      vim.api.nvim_set_keymap("o", "gs", "<cmd>Pounce<CR>", {}) -- 's' is used by vim-surround
    end,
  }
  use { "beauwilliams/focus.nvim", config = function() require("focus").setup() end }
  use { "tpope/vim-scriptease" } -- add :Verbose map etc
  use { 'junegunn/fzf' }
  use {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    config = function()
      -- magic float window is bugging out
      require('bqf').setup({ magic_window = false })
    end
  }

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

  -- should be fixed by now: https://github.com/nvim-treesitter/nvim-treesitter/issues/1957
  -- use { 'elixir-editors/vim-elixir' }

  -- meh
  -- use {
  --   "github/copilot.vim",
  -- }
  -- use {
  --   "zbirenbaum/copilot.lua",
  --   after = { "copilot.vim" },
  -- }
  -- use {
  --   "zbirenbaum/copilot-cmp",
  --   after = { "copilot.lua", "nvim-cmp" },
  -- }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
