local cmp = require('cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'copilot' },
    },
    view = {
        entries = {
            name = "custom",
            selection_order = "near_cursor",
            follow_cursor = true,
        },
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
