local noice = require("noice")
local git_blame = require('gitblame')

local function searchcount()
    local sc = vim.fn.searchcount({ recompute = 1 })
    if sc.total == 0 then
        return ""
    end
    return string.format("[%d/%d]", sc.current, sc.total)
end

require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff', 'diagnostics', { noice.api.statusline.mode.get, cond = noice.api.statusline.mode.has, color = { fg = "#ff9e64" }, } },
        lualine_c = { 'lsp_progress', { 'filename', path = 1 } },

        lualine_x = { searchcount, 'selectioncount', { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }, 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    options = { refresh = { statusline = 100 } },
}
