local noice = require("noice")

require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff', 'diagnostics', { noice.api.statusline.mode.get, cond = noice.api.statusline.mode.has, color = { fg = "#ff9e64" }, } },
        lualine_c = { 'lsp_progress', { 'filename', path = 1 } },

        lualine_x = { { 'searchcount', maxcount = 9999 }, 'selectioncount', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    options = { refresh = { statusline = 100 } },
}
