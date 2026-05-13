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

local function organize_then_format(bufnr)
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if #clients == 0 then return end

    local client = clients[1]
    local enc = client.offset_encoding or "utf-16"
    local tick = vim.api.nvim_buf_get_changedtick(bufnr)

    local params = vim.lsp.util.make_range_params(nil, enc)
    ---@diagnostic disable-next-line: inject-field
    params.context = { only = { "source.organizeImports" }, diagnostics = {} }

    client:request("textDocument/codeAction", params, function(_, result)
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        if vim.api.nvim_buf_get_changedtick(bufnr) ~= tick then return end

        for _, action in pairs(result or {}) do
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, enc)
            end
        end

        vim.lsp.buf.format({ bufnr = bufnr, async = false })
        if vim.bo[bufnr].modified then
            vim.api.nvim_buf_call(bufnr, function()
                vim.cmd("noautocmd silent keepalt write")
            end)
        end
    end, bufnr)
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.go", "*.lua", "*.ts" },
    callback = function(args)
        organize_then_format(args.buf)
    end,
})
