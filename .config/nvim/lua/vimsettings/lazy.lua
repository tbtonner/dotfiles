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
    { "folke/flash.nvim" },
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
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "nvim-treesitter/nvim-treesitter" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "nvim-lua/plenary.nvim" },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
        },
    }
})
