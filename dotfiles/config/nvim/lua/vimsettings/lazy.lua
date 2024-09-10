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
    "lewis6991/gitsigns.nvim",

    "tpope/vim-commentary",

    "tpope/vim-repeat",

    "jiangmiao/auto-pairs",

    "knsh14/vim-github-link",

    "christoomey/vim-tmux-navigator",

    "arkav/lualine-lsp-progress",

    "AndrewRadev/splitjoin.vim",

    "ryanoasis/vim-devicons",

    "ray-x/go.nvim",

    "tpope/vim-surround",

    "tpope/vim-fugitive",

    "nvim-tree/nvim-tree.lua",

    "nvim-treesitter/nvim-treesitter",

    "tpope/vim-unimpaired",

    {
        "vim-test/vim-test",
        dependencies = {
            "preservim/vimux",
        },
    },

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },

    },

    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require 'lsp_signature'.setup(opts) end
    },

    {
        "rebelot/kanagawa.nvim",
        lazy = false,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build"
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
})
