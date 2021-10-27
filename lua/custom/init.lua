-- This is where you custom modules and plugins goes.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

hooks.override("lsp", "publish_diagnostics", function(current)
  current.virtual_text = false;
  return current;
end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

-- hooks.add("install_plugins", function(use)
--    use {
--       "max397574/better-escape.nvim",
--       event = "InsertEnter",
--    }
-- end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"



-- Sane defaults

vim.o.breakindent = true -- Enable break indent
-- vim.o.lazyredraw = true -- handy when running macros on big files
vim.wo.signcolumn = "yes" -- always show the signcolumn
-- vim.o.termguicolors = true -- using highlight attributes

-- Personal settings

vim.opt.swapfile = false
vim.opt.writebackup = false
vim.g.netrw_banner = 0
vim.o.softtabstop = 2
vim.o.scrolloff = 5
vim.o.colorcolumn = "80"
vim.api.nvim_command("highlight! link ColorColumn CursorLine") -- make cursorline same color as colorcolumn
vim.o.cursorline = true
-- vim.o.completeopt = "menuone,noselect" -- no auto selection, also show for 1 option
-- vim.o.background = "dark"



-- Personal mappings

-- disable entering Ex mode
vim.api.nvim_set_keymap("n", "Q", "<Nop>", {})
vim.api.nvim_set_keymap("v", "Q", "<Nop>", {})

vim.api.nvim_set_keymap("n", "<c-t>", ":tabnew<cr>", {})
vim.api.nvim_set_keymap("n", "<tab>", ":tabn<cr>", {})
vim.api.nvim_set_keymap("n", "<S-tab>", ":tabp<cr>", {})

--  retain visual selection after indent
vim.api.nvim_set_keymap("v", ">", ">gv", {})
vim.api.nvim_set_keymap("v", "<", "<gv", {})

-- highlight until end of line
vim.api.nvim_set_keymap("n", "Y", "y$", {})

-- keeps window centered on finding next / prev
vim.api.nvim_set_keymap("n", "n", "nzzzv", {})
vim.api.nvim_set_keymap("n", "N", "Nzzzv", {})

 -- esc twice to remove hlsearch
vim.api.nvim_set_keymap("n", "<esc><esc>", ":nohlsearch<cr>", {})

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", {noremap = true, silent = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Remap for dealing with word wrap
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", {noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", {noremap = true, expr = true, silent = true})

-- Highlight on yank
vim.api.nvim_exec(
    [[
      augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank()
      augroup end
    ]],
    false
)

-- Y yank until the end of line
vim.api.nvim_set_keymap("n", "Y", "y$", {noremap = true})




hooks.add("install_plugins", function(use)
  use {"tpope/vim-unimpaired", opt = true} --, event = 'VimEnter'}  -- extra mappings like [q for quickfix navigations
  use {"tpope/vim-repeat",  event = 'BufModifiedSet'  } -- repeat plugin maps as a whole
  use {"tpope/vim-abolish", event = "CmdlineEnter"} -- replace variations of lower/upper case
  use {"machakann/vim-sandwich", event = "BufRead"} --, event = 'CursorMoved' } -- better add, replace, delete surrounds
  use {"ntpeters/vim-better-whitespace", event = "BufRead"} --, event = 'CursorMoved' } -- highlight trailing whitespaces
  -- comments for combined syntaxes like jsx / tsx
  use {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = {"nvim-treesitter"},
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
    "lifepillar/vim-solarized8",
    --, event = "VimEnter"
    config = function()
      vim.api.nvim_exec(
          [[
            autocmd vimenter * ++nested colorscheme solarized8
          ]],
          false
      )
    end
  }
  use {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }
end)
