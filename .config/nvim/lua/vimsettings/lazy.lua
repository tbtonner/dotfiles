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
    { "chrisgrieser/nvim-various-textobjs" },
    { "lewis6991/gitsigns.nvim" },
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
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { "ray-x/lsp_signature.nvim" },
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "nvim-treesitter/nvim-treesitter" },
    { "rebelot/kanagawa.nvim",                      lazy = false },
    { "williamboman/mason.nvim",                    version = "1.11.0" },
    { "williamboman/mason-lspconfig.nvim",          version = "1.32.0" },
    { "vim-test/vim-test",                          dependencies = { "preservim/vimux" } },
    { "nvim-neo-tree/neo-tree.nvim",                dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
    { "nvim-telescope/telescope.nvim",              dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-lualine/lualine.nvim",                  dependencies = { "nvim-tree/nvim-web-devicons" } },
})
