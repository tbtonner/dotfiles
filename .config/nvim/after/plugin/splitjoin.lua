local splitjoin = require('treesj')

splitjoin.setup({
    use_default_keymaps = false,
})

vim.keymap.set('n', 'gS', splitjoin.split)
