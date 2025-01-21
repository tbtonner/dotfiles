local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        require('go.format').goimport()
    end,
    group = format_sync_grp,
})

require 'go'.setup()

vim.keymap.set("n", "ta", ":GoAddTag -transform camelcase json<cr>")
vim.keymap.set("n", "tr", ":GoRmTag<cr>")
