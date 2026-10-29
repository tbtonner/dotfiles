vim.g.mapleader        = " "
vim.opt.shell          = "/bin/bash"

vim.opt.spelllang      = "en_gb"
vim.opt.clipboard      = "unnamedplus"
-- WSL: use the Windows clipboard directly. WSLg (which wl-copy needs) is disabled: its compositor crash-looped and
-- stole focus every couple of minutes
if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "win32yank",
        copy = { ["+"] = "win32yank.exe -i --crlf", ["*"] = "win32yank.exe -i --crlf" },
        paste = { ["+"] = "win32yank.exe -o --lf", ["*"] = "win32yank.exe -o --lf" },
        cache_enabled = 0,
    }
end

vim.opt.guicursor      = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkon0"

vim.opt.nu             = true
vim.opt.relativenumber = true
vim.opt.wrap           = true
vim.opt.showbreak      = "> "

vim.opt.cursorline     = true
vim.opt.showmode       = false

vim.opt.ignorecase     = true
vim.opt.smartcase      = true

vim.opt.colorcolumn    = "120"
vim.opt.textwidth      = 120

vim.opt.smartindent    = true
vim.opt.breakindent    = true

vim.opt.tabstop        = 4
vim.opt.softtabstop    = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true

vim.opt.scrolloff      = 10
vim.opt.updatetime     = 100

vim.opt.signcolumn     = "yes"

vim.opt.undofile       = true
vim.opt.undodir        = vim.fn.stdpath("data") .. "/undo"

-- No hard wrap or ruler in markdown/text/Claude Code transcripts; long lines still soft-wrap visually via `wrap`.
-- colorcolumn is window-local, so reapply on BufWinEnter too: FileType fires once per buffer and a split or reused
-- window would otherwise keep the 120 ruler.
local prose_filetypes = { markdown = true, text = true, cctranscript = true }

-- Turns off textwidth and the ruler for the current window if its buffer is a prose filetype.
local function clear_prose_ruler()
    if not prose_filetypes[vim.bo.filetype] then
        return
    end
    vim.opt_local.textwidth   = 0
    vim.opt_local.colorcolumn = ""
end

vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, { callback = clear_prose_ruler })
