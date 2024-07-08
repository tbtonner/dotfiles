require('kanagawa').setup({
    commentStyle = { italic = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    transparent = false,
    terminalColors = true,
    theme = "wave",
})

vim.cmd("colorscheme kanagawa")
