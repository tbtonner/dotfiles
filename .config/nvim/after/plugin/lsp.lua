vim.opt.signcolumn = 'yes'

require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = true,
})

vim.lsp.config("*", {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    settings = {
        gopls = {
            env = { GOFLAGS = "-tags=integration" }
        }
    },
})

vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_set_keymap('n', ']e', '<cmd>lua vim.diagnostic.goto_next()<CR>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[e', '<cmd>lua vim.diagnostic.goto_prev()<CR>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']]', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go", "*.lua", "*.ts" },
    callback = function()
        vim.lsp.buf.format()
        vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
        vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
    end
})
