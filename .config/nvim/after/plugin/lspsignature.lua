require("lsp_signature").setup({
    hint_enable = false,
    always_trigger = true,
    handler_opts = { border = "none" },
})

vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {})
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment" })
