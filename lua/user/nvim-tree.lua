-- https://github.com/LunarVim/Neovim-from-scratch/issues/124
vim.g = {
    auto_close = true, -- do not close when it is last window
    update_to_buf_dir = {
        enable = false,
        auto_open = false,
    },
    auto_resize = true,
    quit_on_open = 0,
    git_hl = 1,
    disable_window_picker = 0,
    root_folder_modifier = ":t",
    show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_alrows = 1,
        tree_width = 30,
    },
}

-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    git = {
        unstaged = "",
        staged = "S",
        unmerged = "",
        renamed = "➜",
        deleted = "",
        untracked = "U",
        ignored = "◌",
    },
    folder = {
        default = "",
        open = "",
        empty = "",
        empty_open = "",
        symlink = "",
    },
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
    return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
    -- disable_netrw = true,
    -- hijack_netrw = true,
    open_on_setup = false,
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    open_on_tab = false,
    hijack_cursor = false,
    update_cwd = true,
    diagnostics = {
        enable = true,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 45,
        height = 30,
        hide_root_folder = false,
        side = "left",
        mappings = {
            custom_only = false,
            list = {
                { key = { "<CR>", "o", "i" }, cb = tree_cb "edit" },
                { key = "t", cb = tree_cb "tabnew" },
                { key = "h", cb = tree_cb "close_node" },
                { key = "v", cb = tree_cb "vsplit" },
                { key = "s", cb = tree_cb "split" },
            },
        },
        number = false,
        relativenumber = false,
    },
}

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)
