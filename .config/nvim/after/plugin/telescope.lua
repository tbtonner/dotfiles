local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

local function picker(name, extra)
    local opts = vim.tbl_extend("force", { initial_mode = "normal" }, extra or {})
    return function() builtin[name](opts) end
end

vim.keymap.set('n', '<C-p>', builtin.find_files)
vim.keymap.set("n", "<C-f>", function() builtin.live_grep({ additional_args = { "--fixed-strings" } }) end)
vim.keymap.set("n", "<leader>tr", ":Telescope resume<cr>")

vim.keymap.set("n", "gb", picker("buffers", { show_line = false }))
vim.keymap.set("n", "gd", picker("lsp_definitions", { show_line = false }))
vim.keymap.set("n", "gi", picker("lsp_implementations", { show_line = false }))
vim.keymap.set("n", "gr", picker("lsp_references", { show_line = false, include_declaration = false, include_current_line = false }))
vim.keymap.set("n", "ge", picker("diagnostics", { show_line = false, severity_limit = "Error" }))
vim.keymap.set("n", "gJ", picker("jumplist", { show_line = false }))

vim.keymap.set("n", "gf", picker("treesitter"))
vim.keymap.set("n", "gq", picker("quickfix"))
vim.keymap.set("n", "gn", function() require("telescope").extensions.noice.noice({ initial_mode = "normal" }) end)
vim.keymap.set("n", "gm", function()
    local output = vim.fn.execute("messages")
    local lines = vim.split(output, "\n", { trimempty = true })
    local reversed = {}
    for i = #lines, 1, -1 do reversed[#reversed + 1] = lines[i] end
    local previewer = require("telescope.previewers").new_buffer_previewer({
        title = "Message",
        define_preview = function(self, entry)
            vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(entry.value, "\n"))
            vim.api.nvim_set_option_value("wrap", true, { win = self.state.winid })
        end,
    })
    require("telescope.pickers").new({}, {
        prompt_title = "Messages",
        finder = require("telescope.finders").new_table({ results = reversed }),
        sorter = require("telescope.config").values.generic_sorter({}),
        previewer = previewer,
        initial_mode = "normal",
    }):find()
end)

local focus_preview = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local current_picker = action_state.get_current_picker(prompt_bufnr)
    local prompt_win = current_picker.prompt_win
    local previewer = current_picker.previewer
    local winid = previewer.state.winid
    local bufnr = previewer.state.bufnr
    vim.keymap.set("n", "<Tab>", function()
        vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
    end, { buffer = bufnr })
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
end

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "mocks",
        },
        mappings = {
            i = {
                ["<C-space>"] = actions.to_fuzzy_refine,
                ["<C-q>"] = actions.send_to_qflist,
            },
            n = {
                ["<C-space>"] = actions.to_fuzzy_refine,
                ["<C-q>"] = actions.send_to_qflist,
                ["<Tab>"] = focus_preview,
                ['<C-c>'] = actions.delete_buffer,
                ['dd'] = actions.delete_buffer,
            },
        },
    },
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('noice')
