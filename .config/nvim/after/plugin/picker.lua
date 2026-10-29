local Snacks = require("snacks")

local function no_mocks(item)
    return not (item.file and item.file:find("mocks", 1, true))
end

-- Opens with the result list focused (normal mode) rather than the prompt.
local function picker(name, extra)
    local opts = vim.tbl_extend("force", { focus = "list" }, extra or {})
    return function() Snacks.picker[name](opts) end
end

local function messages()
    local lines = vim.split(vim.fn.execute("messages"), "\n", { trimempty = true })
    local items = {}
    for i = #lines, 1, -1 do
        items[#items + 1] = { text = lines[i], preview = { text = lines[i] } }
    end
    Snacks.picker({
        title = "Messages",
        items = items,
        format = "text",
        preview = "preview",
        focus = "list",
        confirm = { "yank", "close" },
        win = { preview = { wo = { wrap = true } } },
    })
end

vim.keymap.set("n", "<C-p>", function() Snacks.picker.files() end)
vim.keymap.set("n", "<C-f>", function() Snacks.picker.grep({ regex = false }) end)
vim.keymap.set("n", "<leader>tr", function() Snacks.picker.resume() end)

vim.keymap.set("n", "gb", picker("buffers"))
vim.keymap.set("n", "gd", picker("lsp_definitions", { transform = no_mocks }))
vim.keymap.set("n", "gi", picker("lsp_implementations", { transform = no_mocks }))
vim.keymap.set("n", "gr", picker("lsp_references", { include_declaration = false, transform = no_mocks }))
vim.keymap.set("n", "ge", picker("diagnostics", { severity = vim.diagnostic.severity.ERROR }))
vim.keymap.set("n", "gJ", picker("jumps"))

vim.keymap.set("n", "gf", picker("treesitter"))
vim.keymap.set("n", "gq", picker("qflist"))
vim.keymap.set("n", "gn", function() require("noice.integrations.snacks").open({ focus = "list" }) end)
vim.keymap.set("n", "gm", messages)
