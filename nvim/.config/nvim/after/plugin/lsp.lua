local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

local lspconfig = require'lspconfig'

lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

local cmp = require('cmp')
cmp.setup({
    mapping = {
        ['<CR>'] = cmp.mapping.confirm({select = false}),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        lsp.default_setup,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
    },
})

lspconfig.gopls.setup{
    settings = {
        gopls =  {
            env = {GOFLAGS="-tags=integration,gofuzz,developer,runtime"}
        }
    },
    on_attach = function(_, bufnr)
        require "lsp_signature".on_attach({
            bind = true,
            floating_window = false,
            hint_prefix = "🐢 ",
        }, bufnr)
    end,
}

vim.diagnostic.config({ virtual_text = true })
vim.api.nvim_set_keymap('n', '<leader>en', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ep', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>el', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
