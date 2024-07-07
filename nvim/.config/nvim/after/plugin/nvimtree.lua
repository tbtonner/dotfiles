vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup {
    update_focused_file = {
        enable = true,
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
}

vim.keymap.set("n", "<F1>", ":NvimTreeToggle<cr>")
