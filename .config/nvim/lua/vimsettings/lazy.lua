local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup({
    {
        "folke/lazydev.nvim",
    },

    {
        "m00qek/baleia.nvim",
        lazy = true,
    },

    {
        "LunarVim/bigfile.nvim",
        event = "BufReadPre",
        opts = {},
    },

    {
        "stevearc/dressing.nvim",
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
        "ray-x/lsp_signature.nvim",
        event = "LspAttach",
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
        "christoomey/vim-tmux-navigator",
    },

    {
        "nvim-tree/nvim-web-devicons",
    },

    {
        "kylechui/nvim-surround",
        opts = {},
    },

    {
        "tpope/vim-unimpaired",
    },

    {
        "nvim-telescope/telescope.nvim",
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
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
        "nvim-lua/plenary.nvim",
    },

    {
        "rebelot/kanagawa.nvim",
    },

    {
        "milanglacier/minuet-ai.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local model = "qwen2.5-coder:3b-base"

            require("minuet").setup({
                provider = "openai_fim_compatible",
                n_completions = 1,
                context_window = 512,
                request_timeout = 5,
                throttle = 400,
                debounce = 100,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = "TERM",
                        name = "Ollama",
                        end_point = "http://localhost:11434/v1/completions",
                        model = model,
                        optional = {
                            max_tokens = 64,
                            top_p = 0.9,
                        },
                        template = {
                            prompt = function(before, after, _)
                                return "<|fim_prefix|>" .. before .. "<|fim_suffix|>" .. after .. "<|fim_middle|>"
                            end,
                            suffix = false,
                        },
                    },
                },
                lsp = {
                    enabled_ft = { "*" },
                    completion = { enable = false },
                    inline_completion = {
                        enable = true,
                        enabled_auto_trigger_ft = { "*" },
                    },
                },
            })

            vim.lsp.inline_completion.enable(true)

            vim.keymap.set({ "n", "i" }, "<C-t>", function()
                if vim.lsp.inline_completion.get() then
                    return
                end
                return "<C-t>"
            end, { expr = true, silent = true, desc = "Accept inline completion" })
        end,
    },

    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()

            local ls = require("luasnip")
            local iferr = ls.snippet("iferr", {
                ls.text_node({ "if err != nil {", "\treturn " }),
                ls.insert_node(1, "err"),
                ls.text_node({ "", "}" }),
            })
            ls.add_snippets("go", { iferr })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "go",
                callback = function()
                    vim.keymap.set("n", "<leader>if", function()
                        local row = vim.api.nvim_win_get_cursor(0)[1]
                        local indent = vim.api.nvim_get_current_line():match("^(%s*)")
                        vim.api.nvim_buf_set_lines(0, row, row, false, { indent })
                        vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
                        vim.cmd("startinsert!")
                        vim.schedule(function() ls.snip_expand(iferr) end)
                    end, { buffer = true, desc = "Insert if err != nil block" })
                end,
            })
        end,
    },

    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            { "xzbdmw/colorful-menu.nvim", opts = {} },
            "L3MON4D3/LuaSnip",
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
            snippets = {
                preset = "luasnip",
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

    -- Actually lazy

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

    {
        "ruifm/gitlinker.nvim",
        keys = {
            { "<leader>gl", mode = { "n", "v" } },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("gitlinker").setup({
                mappings = nil,
                opts = {
                    add_current_line_on_normal_mode = true,
                },
            })
            local actions = require("gitlinker.actions")
            vim.keymap.set("n", "<leader>gl", function()
                require("gitlinker").get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
            end, { desc = "Copy git link" })
            vim.keymap.set("v", "<leader>gl", function()
                require("gitlinker").get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            end, { desc = "Copy git link for range" })
        end,
    },

    {
        "fredrikaverpil/pr.nvim",
        cmd = "PRView",
        keys = {
            {
                "<leader>gp",
                "<cmd>PRView<cr>",
            },
        },
        config = true,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        cmd = "Neotree",
        keys = {
            {
                "<F1>",
                "<cmd>Neotree filesystem reveal toggle<cr>",
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
            "nvim-lua/plenary.nvim",
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("neotree_hijack_dir", { clear = true }),
                once = true,
                callback = function()
                    if package.loaded["neo-tree"] then return end
                    local stats = vim.uv.fs_stat(vim.fn.argv(0))
                    if stats and stats.type == "directory" then
                        require("neo-tree")
                    end
                end,
            })
        end,
        config = function()
            require("neo-tree").setup({
                event_handlers = {
                    {
                        event = "file_open_requested",
                        handler = function()
                            require("neo-tree.command").execute({ action = "close" })
                        end,
                    },
                    {
                        event = "neo_tree_buffer_enter",
                        handler = function()
                            vim.opt_local.relativenumber = true
                            vim.opt_local.nu = true
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
                        ["<Esc>"] = function(state)
                            require("neo-tree.command").execute({
                                action = "close",
                                source = state.source,
                            })
                        end,
                    },
                },
            })
        end,
    },

})
