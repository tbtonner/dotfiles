vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

local cmp = require('cmp')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'copilot' },
    },
    mapping = cmp.mapping.preset.insert({
        ['<cr>'] = cmp.mapping.confirm({ select = true }),
        ['<down>'] = cmp.mapping.scroll_docs(-4),
        ['<up>'] = cmp.mapping.scroll_docs(4),
        ['<C-space>'] = cmp.mapping.complete(),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

require('mason').setup({})
require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})


require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim', 'require' } },
        },
    },
}

require('lspconfig').gopls.setup({
    settings = {
        gopls = {
            env = { GOFLAGS = "-tags=integration" }
        }
    },
    on_attach = function(_, bufnr)
        -- Floating turtle hints
        require "lsp_signature".on_attach({
            bind = true,
            floating_window = false,
            hint_prefix = "🐢 ",
        }, bufnr)
    end,
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
