require("neo-tree").setup({
    event_handlers = {
        {
            event = "file_open_requested",
            handler = function()
                require("neo-tree.command").execute({ action = "close" })
            end
        },
        {
            event = "neo_tree_buffer_enter",
            handler = function()
                vim.opt_local.relativenumber = true
            end,
        },
    },
    default_component_configs = {
        git_status = {
            symbols = {
                added     = "",
                modified  = "",
                deleted   = "",
                renamed   = "",
                untracked = "",
                ignored   = "",
                unstaged  = "",
                staged    = "",
                conflict  = "",
            },
        },
    },
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
        },
    },
    window = {
        mappings = {
            ["/"] = "noop",
            ["f"] = "noop",
            ["<C-f>"] = "noop",
        },
    },
})

vim.keymap.set("n", "<F1>", ":Neotree filesystem reveal toggle<cr>")
