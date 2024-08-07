local builtin = require('telescope.builtin')

require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "mocks"
        }
    }
}

local ignoremocks = {
    on_complete = {
        function(picker)
            picker:clear_completion_callbacks()
            if picker.manager.linked_states.size == 1 then
                require("telescope.actions").select_default(picker.prompt_bufnr)
            end
        end,
    },
    initial_mode = "normal",
    show_line = false,
    include_current_line = false
}

vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<C-f>', builtin.live_grep, {})
vim.keymap.set("n", "<leader>tr", ":Telescope resume<cr>")

vim.keymap.set("n", "gb", function() builtin.buffers({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gd", function() builtin.lsp_definitions({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gi", function() builtin.lsp_implementations(ignoremocks) end, {})
vim.keymap.set("n", "gr", function() builtin.lsp_references(ignoremocks) end, {})
vim.keymap.set("n", "ge", function() builtin.diagnostics({ initial_mode = "normal", show_line = false }) end, {})

vim.keymap.set("n", "gf", function() builtin.treesitter({ initial_mode = "normal" }) end, {})
vim.keymap.set("n", "gj", function() builtin.jumplist({ initial_mode = "normal", show_line = false }) end, {})
vim.keymap.set("n", "gm", function() builtin.marks({ initial_mode = "normal" }) end, {})

require('telescope').load_extension('fzf')
