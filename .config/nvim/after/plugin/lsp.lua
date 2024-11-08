vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
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
            diagnostics = {globals = {'vim', 'require'}},
        },
    },
}

require('lspconfig').gopls.setup({
    settings = {
        gopls = {
            env = {GOFLAGS = "-tags=integration"}
        }
    },
    on_attach = function(_, bufnr)
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
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
