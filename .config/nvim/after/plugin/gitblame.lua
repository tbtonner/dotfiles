require('blame').setup {
    relative_date_if_recent = false,
    date_format = "%Y-%m-%d",
}

vim.keymap.set("n", "<leader>gb", ':BlameToggle window<cr>')

require('gitblame').setup {
    message_template = " <author> • <date> ",
    date_format = "%Y-%m-%d",
}

vim.g.gitblame_display_virtual_text = 0
vim.g.gitblame_message_when_not_committed = ''
