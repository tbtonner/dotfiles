require('lualine').setup {
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {{ 'filename', path = 1, }, 'lsp_progress'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'},
    },
    options = {refresh = {statusline = 100}},
}
