require('blame').setup {
    relative_date_if_recent = false,
}

vim.keymap.set("n", "<leader>gn", ':BlameToggle virtual<cr>')
vim.keymap.set("n", "<leader>gb", ':BlameToggle window<cr>')
