local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- gitbrowse opens the URL by default; copy it instead.
local function copy_url(url)
    vim.fn.setreg("+", url)
    vim.notify("Copied " .. url)
end

require("lazy").setup({
    {
        "folke/lazydev.nvim",
    },

    {
        "m00qek/baleia.nvim",
        lazy = true,
    },

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            {
                "<leader>gl",
                function()
                    require("snacks").gitbrowse({ what = "permalink", open = copy_url, notify = false })
                    if vim.fn.mode():find("[vV]") then
                        vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
                    end
                end,
                mode = { "n", "x" },
                desc = "Copy git link",
            },
        },
        opts = {
            bigfile = {},
            explorer = {},
            -- The PR view folds by markdown section; open it expanded rather than at the default foldlevel of 0.
            gh = { wo = { foldlevel = 99 } },
            image = {},
            input = {},
            quickfile = {},
            picker = {
                ui_select = true,
                sources = {
                    explorer = {
                        hidden = true,
                        jump = { close = true },
                        layout = { preset = "sidebar", preview = false, hidden = { "input" } },
                        win = {
                            list = {
                                -- Plain buffer search instead of jumping to the filter prompt.
                                keys = { ["/"] = false },
                                wo = { number = true, relativenumber = true },
                            },
                        },
                    },
                    files = { hidden = true, exclude = { "mocks" } },
                    grep = { exclude = { "mocks" } },
                    buffers = {
                        win = { list = { keys = { ["<C-c>"] = "bufdelete" } } },
                    },
                },
                win = {
                    input = {
                        keys = { ["<C-space>"] = { "toggle_live", mode = { "i", "n" } } },
                    },
                    list = {
                        keys = {
                            ["<C-space>"] = "toggle_live",
                            ["<Tab>"] = "focus_preview",
                        },
                    },
                    preview = {
                        keys = { ["<Tab>"] = "focus_list" },
                    },
                },
            },
        },
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            current_line_blame = true,
            current_line_blame_opts = { virt_text = false, delay = 300 },
            current_line_blame_formatter = ' <author> • <author_time:%Y-%m-%d> ',
            current_line_blame_formatter_nc = '',
        },
    },

    {
        "FabijanZulj/blame.nvim",
    },

    {
        "neovim/nvim-lspconfig",
    },

    {
        "folke/ts-comments.nvim",
        opts = {},
    },

    {
        "tpope/vim-repeat",
    },

    {
        "windwp/nvim-autopairs",
    },

    {
        "nvim-tree/nvim-web-devicons",
    },

    {
        "kylechui/nvim-surround",
        opts = {},
    },

    {
        "folke/noice.nvim",
    },

    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
    },



    {
        "nvim-lualine/lualine.nvim",
    },

    {
        "rebelot/kanagawa.nvim",
    },

    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "xzbdmw/colorful-menu.nvim", opts = {} },
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = {
                preset = "none",
                ["\21"] = { "select_and_accept" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-space>"] = { "show" },
            },
            signature = {
                enabled = true,
                window = { border = "none" },
            },
            sources = {
                default = { "lsp", "snippets", "buffer" },
            },
            completion = {
                menu = {
                    border = "none",
                    draw = {
                        treesitter = { "lsp" },
                        components = {
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    window = { border = "none" },
                },
            },
        },
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        opts = {
            format_after_save = {},
            formatters_by_ft = {
                go                = { "goimports" },
                typescript        = { "prettier" },
                typescriptreact   = { "prettier" },
                javascript        = { "prettier" },
                javascriptreact   = { "prettier" },
            },
        },
    },

    {
        "mason-org/mason.nvim",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
        },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown" },
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            ignore = function(buf)
                local win = vim.fn.bufwinid(buf)
                if win == -1 then
                    return false
                end
                return vim.api.nvim_win_get_config(win).relative ~= ""
            end,
        },
    },

    {
        "chrisgrieser/nvim-various-textobjs",
        event = "VeryLazy",
        main = "various-textobjs",
        opts = {
            keymaps = {
                useDefaults = true,
            },
        },
    },

    {
        "folke/flash.nvim",
        keys = {
            {
                "s",
                function() require("flash").jump() end,
                mode = {
                    "n",
                    "x",
                    "o",
                },
            },
        },
        opts = {},
    },

    {
        "Wansmer/treesj",
        keys = {
            {
                "gS",
                function() require("treesj").split() end,
            },
        },
        opts = {
            use_default_keymaps = false,
        },
    },

})
