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
        opts = {},
    },

    {
        "FabijanZulj/blame.nvim",
    },

    {
        "f-person/git-blame.nvim",
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
        "saghen/blink.cmp",
        version = "*",
        dependencies = { { "xzbdmw/colorful-menu.nvim", opts = {} } },
        opts = {
            keymap = {
                preset = "none",
                ["\21"] = { "select_and_accept" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-space>"] = { "show" },
            },
            sources = {
                default = { "lsp", "buffer" },
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
        opts = {},
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
        "greggh/claude-code.nvim",
        keys = {
            "<leader>at",
            "<leader>ai",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {
            window = {
                position = "vertical botright",
            },
            keymaps = {
                toggle = {
                    terminal = "<leader>at",
                    variants = {
                        continue = "<leader>ai",
                    },
                },
            },
        },
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

    {
        "nvim-neotest/neotest",
        keys = {
            "<Leader>tn",
            "<Leader>tf",
            "<Leader>td",
            "<Leader>tt",
        },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "fredrikaverpil/neotest-golang",
                commit = "cac1039",
            },
        },
        config = function()
            local notify_consumer = function(client)
                local function read_output(result)
                    local output = result.output
                    if not output then return "" end
                    if type(output) == "string" then
                        local f = io.open(output, "r")
                        if f then
                            output = f:read("*a"); f:close()
                        end
                    end
                    return output:gsub("\27%[[0-9;]*m", "")
                end

                client.listeners.run = function(_, _, position_ids)
                    vim.schedule(function()
                        local msg = "Running tests..."
                        if position_ids and #position_ids == 1 then
                            local name = position_ids[1]:match("::(.+)$")
                                or position_ids[1]:match(".+/([^/]+)$")
                                or position_ids[1]
                            msg = "Running " .. name .. "..."
                        end
                        vim.notify(msg, vim.log.levels.INFO, {
                            title = "Neotest",
                        })
                    end)
                end

                client.listeners.results = function(_, results, partial)
                    if partial then return end

                    local failure_statuses = {
                        failed = true,
                        failure = true,
                        error = true,
                    }
                    local grouped_failures = {}

                    for test_id, result in pairs(results) do
                        if test_id:match("::") then
                            local top_test = test_id:match("^(.-)::") or test_id
                            if failure_statuses[result.status] then
                                grouped_failures[top_test] = grouped_failures[top_test] or {}
                                table.insert(grouped_failures[top_test], result)
                            end
                        end
                    end

                    vim.schedule(function()
                        if next(grouped_failures) then
                            for top_test, fails in pairs(grouped_failures) do
                                local combined = table.concat(
                                    vim.tbl_map(function(f) return read_output(f) end, fails),
                                    "\n\n"
                                )
                                vim.notify(combined, vim.log.levels.ERROR, {
                                    title = "Neotest Failure: " .. top_test,
                                })
                            end
                            return
                        end
                        vim.notify("All tests passed!", vim.log.levels.INFO, {
                            title = "Neotest",
                        })
                    end)
                end
            end

            ---@diagnostic disable-next-line: missing-fields
            require("neotest").setup({
                adapters = {
                    require('neotest-golang')({
                        runner = "gotestsum",
                        go_test_args = {
                            "-v",
                            "-count=1",
                        },
                        warn_test_name_dupes = false,
                    }),
                },
                consumers = {
                    notify = notify_consumer,
                },
                quickfix = {
                    enabled = false,
                },
                discovery = {
                    enabled = false,
                },
            })

            vim.keymap.set('n', '<Leader>tn', function() require("neotest").run.run() end, {
                desc = 'Run test',
            })
            vim.keymap.set('n', '<Leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end, {
                desc = 'Run file',
            })
            vim.keymap.set('n', '<Leader>td', function() require("neotest").run.run(vim.fn.expand("%:p:h")) end, {
                desc = 'Run dir',
            })
            vim.keymap.set('n', '<Leader>tt',
                function() require("neotest").output.open({ enter = true, auto_close = true }) end, {
                    desc = 'Show test result',
                })
        end,
    },
})
