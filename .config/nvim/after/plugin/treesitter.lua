require("nvim-treesitter").setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.bo[buf].buftype ~= "" then return end
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then return end
        local ts = require("nvim-treesitter")
        if vim.tbl_contains(ts.get_available(), lang) then
            ts.install({ lang })
        end
        pcall(vim.treesitter.start, buf, lang)
        pcall(vim.keymap.del, "n", "]]", { buffer = buf })
        pcall(vim.keymap.del, "n", "[[", { buffer = buf })
    end,
})
