require("lazydev").setup({})
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = true,
})

vim.lsp.config("*", {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.config("gopls", {
    settings = {
        gopls = {
            env = { GOFLAGS = "-tags=integration" },
            directoryFilters = {
                "-bazel-bin", "-bazel-out", "-bazel-testlogs",
                "-bazel-couchbase-cloud", "-bazel-cache",
                "-node_modules", "-.git",
                "-cmd/cp-ui-v2", "-cmd/cp-ui-v3", "-cmd/base-ui", "-cmd/fm-ui-v2",
            },
            symbolMatcher = "fastfuzzy",
            completeUnimported = true,
            usePlaceholders = false,
            semanticTokens = false,
        },
    },
})

vim.diagnostic.config({ virtual_text = true })

local opts = { silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>lr', function()
    for _, client in ipairs(vim.lsp.get_clients({ name = 'gopls' })) do
        client:stop(true)
    end
    vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == 'go' then
                vim.api.nvim_exec_autocmds('FileType', { buffer = buf, modeline = false })
            end
        end
    end, 400)
end, vim.tbl_extend('force', opts, { desc = 'Restart gopls' }))
