local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimports()
    end,
    group = format_sync_grp,
})

require 'go'.setup({
    goimports = 'gopls',
    gofmt = 'gopls',
    lsp_cfg = true,
    lsp_gofumpt = true,
    lsp_on_attach = true,
})

vim.keymap.set("n", "ta", ":GoAddTag -transform camelcase json<cr>")
vim.keymap.set("n", "tr", ":GoRmTag<cr>")
