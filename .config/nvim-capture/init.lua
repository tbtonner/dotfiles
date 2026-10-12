-- Minimal config for tmux capture-to-nvim.sh (NVIM_APPNAME=nvim-capture).
-- Reuses plugins from the main nvim's lazy.nvim install instead of a separate plugin manager.
local lazy = vim.fn.expand("~/.local/share/nvim/lazy/")
for _, plugin in ipairs({ "baleia.nvim", "kanagawa.nvim" }) do
    if vim.fn.isdirectory(lazy .. plugin) == 1 then
        vim.opt.rtp:prepend(lazy .. plugin)
    end
end

vim.opt.termguicolors = true
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.clipboard = "unnamedplus"

local ok, kanagawa = pcall(require, "kanagawa")
if ok then
    kanagawa.setup({ terminalColors = true, theme = "wave" })
    vim.cmd("colorscheme kanagawa")
end

-- read-only viewer: q / Esc quits without prompting
vim.keymap.set("n", "q", "<cmd>qa!<cr>")
vim.keymap.set("n", "<Esc>", "<cmd>qa!<cr>")
