---@diagnostic disable-next-line: missing-fields
require('blame').setup {
    relative_date_if_recent = false,
    date_format = "%Y-%m-%d",
}

vim.keymap.set("n", "<leader>gb", ':BlameToggle window<cr>')

