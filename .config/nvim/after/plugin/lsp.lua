require("lazydev").setup({})
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = true,
})

vim.lsp.config("*", {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Run gopls as a shared daemon so NeoVim and other gopls clients (e.g. Claude Code) reuse one process instead of
-- spawning one each. The daemon address is derived from the gopls binary, so clients must agree on the same path -
-- hence the absolute mason path rather than whatever `gopls` $PATH happens to resolve to.
--
-- https://github.com/golang/tools/blob/master/gopls/doc/daemon.md
vim.lsp.config("gopls", {
    cmd = {
        vim.fn.expand("$HOME/.local/share/nvim/mason/bin/gopls"),
        "-remote=auto",
        "-remote.listen.timeout=1h",
    },
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
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
