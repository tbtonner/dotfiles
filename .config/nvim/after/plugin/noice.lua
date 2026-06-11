require("noice").setup({
    lsp = {
        override = {
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
            input = { view = "cmdline" },
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
        {
            view = "notify",
            filter = {
                event = "msg_show",
                kind = "shell_out",
            },
        },
    },
})
