vim.opt.nu             = true
vim.opt.relativenumber = true

vim.opt.mousescroll    = "ver:1,hor:0"

vim.opt.ruler          = true
vim.opt.colorcolumn    = "120"
vim.opt.textwidth      = 120

vim.opt.termguicolors  = true

vim.opt.wrap           = false
vim.opt.autoindent     = true
vim.opt.smartindent    = true
vim.opt.breakindent    = true

vim.opt.cursorline     = true

vim.opt.ignorecase     = true

vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

vim.opt.encoding       = "UTF-8"
vim.opt.spelllang      = "en"
vim.opt.regexpengine   = 1

vim.opt.clipboard      = 'unnamedplus'

vim.opt.swapfile       = false
vim.opt.backup         = false
vim.opt.undodir        = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile       = true

vim.opt.hlsearch       = true
vim.opt.incsearch      = true

vim.opt.scrolloff      = 10
vim.opt.signcolumn     = "yes"

vim.opt.updatetime     = 50

vim.g.history          = 1000

vim.g.mapleader        = " "
