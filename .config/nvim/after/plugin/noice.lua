require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
        signature = { enabled = false },
    },
    cmdline = {
        view = "cmdline",
        format = {
            cmdline = false,
            search_down = false,
            search_up = false,
            filter = false,
            lua = false,
            help = false,
            input = false
        },
    },
    messages = {
        view_search = false,
    },
    routes = {
        {
            filter = {
                any = {
                    { event = "notify",   find = "No code actions available" },
                    { event = "msg_show", find = "No code actions available" },
                },
            },
            opts = { skip = true },
        },
    },
})
