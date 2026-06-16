local noice = require("noice")

local function gitsigns_blame()
    local line = vim.b.gitsigns_blame_line
    if line ~= nil then
        vim.b._blame_cache = line
        return line
    end
    return vim.b._blame_cache or ""
end

local function searchcount()
    local sc = vim.fn.searchcount({ recompute = 1 })
    if sc.total == 0 then return "" end
    return string.format("󰍉 %d/%d", sc.current, sc.total)
end

local function quickfix_position()
    local qflist = vim.fn.getqflist()
    if #qflist == 0 then return "" end
    local idx = vim.fn.getqflist({ idx = 0 }).idx
    return string.format("󰁨 %d/%d", idx, #qflist)
end

require('lualine').setup {
    sections = {
        lualine_a = { 'mode' },
        lualine_b = {
            'diff',
            'diagnostics',
            ---@diagnostic disable-next-line: undefined-field
            { noice.api.status.mode.get, cond = noice.api.status.mode.has, color = { fg = "#ff9e64" }, },
        },
        lualine_c = { { 'filename', path = 1 } },

        lualine_x = {
            gitsigns_blame,
            { quickfix_position, color = { fg = "#e0af68" } },
            { searchcount, color = { fg = "#7dcfff" } },
            'selectioncount',
            'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    options = { theme = 'kanagawa', refresh = { statusline = 100 } },
}
