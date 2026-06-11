require('kanagawa').setup({
    commentStyle = { italic = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    transparent = true,
    terminalColors = true,
    theme = "wave",
    overrides = function(colors)
        local theme = colors.theme
        return {
            Pmenu      = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            PmenuSel   = { fg = "NONE", bg = theme.ui.bg_p2 },
            PmenuSbar  = { bg = theme.ui.bg_m1 },
            PmenuThumb = { bg = theme.ui.bg_p2 },
            BlinkCmpDoc          = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
            BlinkCmpDocSeparator = { fg = theme.ui.bg_p2, bg = theme.ui.bg_p1 },
        }
    end,
})

vim.cmd("colorscheme kanagawa")
