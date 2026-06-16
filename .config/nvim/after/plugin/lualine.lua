local noice = require("noice")

-- Kanagawa wave palette
local blame_colors = {
    "#7E9CD8",
    "#FFA066",
    "#98BB6C",
    "#E6C384",
    "#957FB8",
    "#E46876",
    "#7AA89F",
    "#7FB4CA",
    "#D27E99",
    "#9CABCA",
}

local function hash_to_color(hash)
    if not hash or hash == "" or hash:match("^0+$") then
        return "#727169"
    end
    local n = 0
    for i = 1, #hash do n = n + string.byte(hash, i) end
    return blame_colors[(n % #blame_colors) + 1]
end

local function gitsigns_blame()
    local line = vim.b.gitsigns_blame_line
    if line ~= nil then
        local dict = vim.b.gitsigns_blame_line_dict
        local sha = dict and dict.sha
        vim.b._blame_cache = line
        if sha and sha ~= "" then
            vim.b._blame_hash_cache = sha
        end
    end
    vim.b._blame_hash = vim.b._blame_hash_cache or ""
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
            { noice.api.status.mode.get, cond = noice.api.status.mode.has, color = { fg = "#FFA066" }, },
        },
        lualine_c = { { 'filename', path = 1 } },

        lualine_x = {
            {
                gitsigns_blame,
                color = function()
                    return { fg = hash_to_color(vim.b._blame_hash) }
                end,
            },
            { quickfix_position, color = { fg = "#E6C384" } },
            { searchcount, color = { fg = "#7E9CD8" } },
            'selectioncount',
            'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
    },
    options = { theme = 'kanagawa', refresh = { statusline = 100 } },
}
