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
    { "ruifm/gitlinker.nvim" },
    { "folke/lazydev.nvim" },
    { "stevearc/dressing.nvim" },
    { "chrisgrieser/nvim-various-textobjs" },
    { "lewis6991/gitsigns.nvim" },
    { "FabijanZulj/blame.nvim" },
    { "f-person/git-blame.nvim" },
    { "neovim/nvim-lspconfig" },
    { 'VonHeikemen/lsp-zero.nvim' },
    { "fredrikaverpil/pr.nvim" },
    { "tpope/vim-commentary" },
    { "tpope/vim-repeat" },
    { "windwp/nvim-autopairs" },
    { "christoomey/vim-tmux-navigator" },
    { "Wansmer/treesj" },
    { "ryanoasis/vim-devicons" },
    { "nvim-tree/nvim-web-devicons", },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
    { "nvim-telescope/telescope.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { "folke/noice.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "nvim-lualine/lualine.nvim" },
    { "nvim-lua/plenary.nvim" },
    { "rebelot/kanagawa.nvim" },
    {
        "folke/flash.nvim",
        config = function()
            require("flash").setup()
        end,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            { "williamboman/mason-lspconfig.nvim" },
        }
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
        }
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                "fredrikaverpil/neotest-golang",
                commit = "cac1039",
            }
        },
    }
})
