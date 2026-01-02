vim.g.mapleader        = " "
vim.opt.shell          = "/bin/bash"

vim.opt.spelllang      = "en_gb"
vim.opt.clipboard      = "unnamedplus"
vim.opt.spellsuggest   = { "best", 9 }

vim.opt.nu             = true
vim.opt.relativenumber = true
vim.opt.wrap           = true
vim.opt.showbreak      = "> "

vim.opt.termguicolors  = true
vim.opt.cursorline     = true
vim.opt.showmode       = false

vim.opt.ignorecase     = true
vim.opt.smartcase      = true

vim.opt.colorcolumn    = "120"
vim.opt.textwidth      = 120

vim.opt.autoindent     = true
vim.opt.smartindent    = true
vim.opt.breakindent    = true

vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

vim.opt.hlsearch       = true
vim.opt.incsearch      = true

vim.opt.scrolloff      = 10
vim.opt.updatetime     = 50

vim.opt.history        = 1000
vim.opt.undofile       = true
vim.opt.undodir        = vim.fn.stdpath("data") .. "/undo"
