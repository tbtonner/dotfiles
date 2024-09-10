local builtin = require('telescope.builtin')
local actions = require("telescope.actions")

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set("n", "<C-f>", function() builtin.live_grep({ additional_args = { "--fixed-strings" } }) end, {})
vim.keymap.set("n", "<leader>tr", ":Telescope resume<cr>")
vim.keymap.set('n', '<leader>tq', builtin.quickfix, {})

vim.keymap.set("n", "gb", function() builtin.buffers({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gd", function() builtin.lsp_definitions({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gi", function() builtin.lsp_implementations({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gr", function() builtin.lsp_references({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "ge", function() builtin.diagnostics({ initial_mode = "normal", show_line = false }) end, {})

vim.keymap.set("n", "gf", function() builtin.treesitter({ initial_mode = "normal" }) end, {})
vim.keymap.set("n", "gj", function() builtin.jumplist({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gm", function() builtin.marks({ initial_mode = "normal" }) end, {})
vim.keymap.set("n", "<leader>ql", function() builtin.quickfix({ initial_mode = "normal" }) end, {})

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "mocks",
        },
        mappings = {
            i = { ["<C-space>"] = actions.to_fuzzy_refine },
            n = { ["<C-space>"] = actions.to_fuzzy_refine },
        },
    },
}

require('telescope').load_extension('fzf')
