require("neotest").setup({
    adapters = {
        require('neotest-go')({})
    },
})

vim.keymap.set('n', '<Leader>tn', ':lua require("neotest").run.run()<CR>', { desc = 'Run test' })
vim.keymap.set('n', '<Leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = 'Run file' })
vim.keymap.set('n', '<Leader>tt', ':lua require("neotest").output.open()<CR>', { desc = 'Show test result' })
