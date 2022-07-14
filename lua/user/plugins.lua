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
    use { "wbthomason/packer.nvim" } -- Have packer manage itself
    use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use { "windwp/nvim-autopairs", event = "InsertEnter" } -- Autopairs, integrates with both cmp and treesitter
    use { "numToStr/Comment.nvim", event = "VimEnter" } -- Easily comment stuff
    use { "kyazdani42/nvim-tree.lua", requires = {
        "kyazdani42/nvim-web-devicons"
    } }
    use "nvim-lualine/lualine.nvim"
    use { "akinsho/toggleterm.nvim", cmd = "ToggleTerm" }
    use { "ahmedkhalf/project.nvim", event = "VimEnter" }
    use "lewis6991/impatient.nvim"
    -- use { "lukas-reineke/indent-blankline.nvim", event = "VimEnter" } -- has issues
    use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
    use { "folke/which-key.nvim" }

    -- cmp plugins
    use { "hrsh7th/nvim-cmp", event = "VimEnter" } -- The completion plugin
    use { "hrsh7th/cmp-buffer", event = "VimEnter" } -- buffer completions
    use { "hrsh7th/cmp-path", event = "VimEnter" } -- path completions
    use { "hrsh7th/cmp-cmdline", event = "VimEnter" } -- cmdline completions
    use { "saadparwaiz1/cmp_luasnip", event = "VimEnter" } -- snippet completions
    use { "hrsh7th/cmp-nvim-lsp", event = "VimEnter" }

    -- snippets
    use { "L3MON4D3/LuaSnip", event = "VimEnter" } --snippet engine
    use { "rafamadriz/friendly-snippets", event = "VimEnter" } -- a bunch of snippets to use

    -- LSP
    use { "neovim/nvim-lspconfig", event = "BufRead" } -- enable LSP
    use { "williamboman/nvim-lsp-installer", event = "VimEnter" } -- simple to use language server installer
    use { "tamago324/nlsp-settings.nvim", event = "VimEnter" } -- language server settings defined in json for
    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

    -- Telescope
    use { "nvim-telescope/telescope.nvim" }

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
    use { "lewis6991/gitsigns.nvim", event = "VimEnter" }
    use { "tpope/vim-fugitive", event = "VimEnter" }

    use { "tpope/vim-unimpaired", event = 'VimEnter' } -- extra mappings like [q for quickfix navigations
    use { "tpope/vim-repeat", event = 'BufModifiedSet' } -- repeat plugin maps as a whole
    use { "tpope/vim-abolish", event = "CmdlineEnter" } -- replace variations of lower/upper case
    use { "machakann/vim-sandwich", event = "VimEnter" } --, event = 'CursorMoved' } -- better add, replace, delete surrounds
    use { "ntpeters/vim-better-whitespace", event = "VimEnter" } --, event = 'CursorMoved' } -- highlight trailing whitespaces
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
        ft = { "typescript", "typescriptreact" },
        after = { "nvim-treesitter" },
        config = function()
            require('nvim-ts-autotag').setup()
        end
    }
    use {
        "jose-elias-alvarez/nvim-lsp-ts-utils",
        ft = { "typescript", "typescriptreact" },
        requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "jose-elias-alvarez/null-ls.nvim" },
    }
    --    -- {
    --    --   "folke/trouble.nvim",
    --    --   requires = "kyazdani42/nvim-web-devicons",
    --    --   config = function()
    --    --     require("trouble").setup {}
    --    --     vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --     vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>TroubleToggle lsp_workspace_diagnostics<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --     vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>TroubleToggle lsp_document_diagnostics<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --     vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --     vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --     vim.api.nvim_set_keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
    --    --       {silent = true, noremap = true}
    --    --     )
    --    --   end
    --    -- }

    --    -- coloschemes

    use { "haystackandroid/stellarized" }
    use {
        "folke/tokyonight.nvim",
        -- after = { "nvim-treesitter" },
        config = function()
            vim.g.tokyonight_day_brightness = 0.1
            vim.g.tokyonight_style = "storm"
        end,
    }
    use {
        "EdenEast/nightfox.nvim",
        config = function()
            vim.cmd [[colorscheme nightfox]]
        end
        -- after = { "nvim-treesitter" },
    }

    use {
        "rlane/pounce.nvim",
        event = "VimEnter",
        config = function()
            -- require("pounce").setup({})
            vim.api.nvim_set_keymap("n", "s", "<cmd>Pounce<CR>", {})
            vim.api.nvim_set_keymap("n", "S", "<cmd>PounceRepeat<CR>", {})
            -- vim.api.nvim_set_keymap("v", "s", "<cmd>Pounce<CR>", {})
            -- vim.api.nvim_set_keymap("o", "gs", "<cmd>Pounce<CR>", {}) -- 's' is used by vim-surround
        end,
    }
    use { "beauwilliams/focus.nvim",
        config = function() require("focus").setup() end,
        event = "VimEnter"
    }
    use { "tpope/vim-scriptease", opt = true } -- add :Verbose map etc
    use { 'junegunn/fzf', event = "VimEnter" }

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
    use { 'editorconfig/editorconfig-vim' }

    -- should be fixed by now: https://github.com/nvim-treesitter/nvim-treesitter/issues/1957
    use { 'elixir-editors/vim-elixir' }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
