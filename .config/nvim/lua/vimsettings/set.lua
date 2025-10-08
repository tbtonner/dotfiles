vim.opt.nu             = true
vim.opt.relativenumber = true

vim.opt.mousescroll    = "ver:1,hor:0"

vim.opt.ruler          = true
vim.opt.colorcolumn    = "120"
vim.opt.textwidth      = 120

vim.opt.wrap           = true
vim.opt.linebreak      = true
vim.opt.wrapmargin     = 0
vim.opt.showbreak      = "  "
vim.opt.formatoptions:append("t")

vim.opt.termguicolors = true

vim.opt.autoindent    = true
vim.opt.smartindent   = true
vim.opt.breakindent   = true

vim.opt.cursorline    = true

vim.opt.showmode      = false

vim.opt.ignorecase    = true

vim.opt.tabstop       = 4
vim.opt.softtabstop   = 4
vim.opt.shiftwidth    = 4
vim.opt.expandtab     = true

vim.opt.encoding      = "UTF-8"
vim.opt.spelllang     = "en"

vim.opt.clipboard     = 'unnamedplus'

vim.opt.swapfile      = false
vim.opt.backup        = false
vim.opt.undodir       = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile      = true

vim.opt.hlsearch      = true
vim.opt.incsearch     = true

vim.opt.scrolloff     = 10
vim.opt.signcolumn    = "yes"

vim.opt.updatetime    = 50

vim.g.history         = 1000

vim.g.mapleader       = " "

vim.opt.shell         = "/bin/bash"
