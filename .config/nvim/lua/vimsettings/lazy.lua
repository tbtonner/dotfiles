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
    { "zbirenbaum/copilot.lua" },
    { "zbirenbaum/copilot-cmp" },
    { "chrisgrieser/nvim-various-textobjs" },
    { "lewis6991/gitsigns.nvim" },
    { "FabijanZulj/blame.nvim" },
    { "fredrikaverpil/pr.nvim" },
    { "tpope/vim-commentary" },
    { "tpope/vim-repeat" },
    { "windwp/nvim-autopairs" },
    { "knsh14/vim-github-link" },
    { "christoomey/vim-tmux-navigator" },
    { "AndrewRadev/splitjoin.vim" },
    { "ryanoasis/vim-devicons" },
    { "tpope/vim-surround" },
    { "tpope/vim-unimpaired" },
    { "arkav/lualine-lsp-progress" },
    { "nvim-telescope/telescope-fzf-native.nvim" },
    { 'VonHeikemen/lsp-zero.nvim' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "nvim-treesitter/nvim-treesitter" },
    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },
    { 'neovim/nvim-lspconfig' },
    { "rebelot/kanagawa.nvim",                      lazy = false },
    { "vim-test/vim-test",                          dependencies = { "preservim/vimux" } },
    { "nvim-neo-tree/neo-tree.nvim",                dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
    { "nvim-telescope/telescope.nvim",              dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-lualine/lualine.nvim",                  dependencies = { "nvim-tree/nvim-web-devicons" } },
})
