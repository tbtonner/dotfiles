require("luasnip.loaders.from_vscode").lazy_load()

require("luasnip.loaders.from_lua").load({
    paths = vim.fn.stdpath("config") .. "/lua/snippets"
})
