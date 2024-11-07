require 'nvim-treesitter.configs'.setup {
    auto_install = true,
    highlight = {
        enable = true,
        disable = function(lang, _)
            return lang == "json"
        end,
    },
}
