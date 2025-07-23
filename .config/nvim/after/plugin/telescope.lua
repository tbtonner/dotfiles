local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set("n", "<C-f>", function() builtin.live_grep({ additional_args = { "--fixed-strings" } }) end, {})
vim.keymap.set("n", "<leader>tr", ":Telescope resume<cr>")

vim.keymap.set("n", "gb", function() builtin.buffers({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gd", function() builtin.lsp_definitions({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gi", function() builtin.lsp_implementations({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gr", function() builtin.lsp_references({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "ge", function() builtin.diagnostics({ initial_mode = "normal", show_line = false }) end, {})

vim.keymap.set("n", "gf", function() builtin.treesitter({ initial_mode = "normal" }) end, {})
vim.keymap.set("n", "gJ", function() builtin.jumplist({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gm", function() builtin.marks({ initial_mode = "normal" }) end, {})
vim.keymap.set("n", "gq", function() builtin.quickfix({ initial_mode = "normal" }) end, {})

local focus_preview = function(prompt_bufnr)
    local action_state = require("telescope.actions.state")
    local picker = action_state.get_current_picker(prompt_bufnr)
    local prompt_win = picker.prompt_win
    local previewer = picker.previewer
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
