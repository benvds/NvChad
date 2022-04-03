-- This is where you custom modules and plugins goes.
-- See the wiki for a guide on how to extend NvChad

local map = require("core.utils").map

map("n", "<leader>s", "<cmd>lua require'hop'.hint_char1()<cr>", {}) -- example to delete the buffer

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
vim.o.pumheight = 15
-- vim.o.completeopt = "menuone,noselect" -- no auto selection, also show for 1 option
vim.o.background = "dark"
vim.opt.wrap = false



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
