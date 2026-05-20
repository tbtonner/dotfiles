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
