vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<F6>", ':set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<cr>')

vim.keymap.set("v", "H", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "L", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<C-d>", ":q!<cr>")
vim.keymap.set("n", "<C-s>", ":silent wa | silent w<cr>")
vim.keymap.set("n", "<C-c>", ':bp | bd #<cr>')

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set("n", "<leader>r", '"_ciw<esc>p')
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [[y:%s/<C-r>"/<C-r>"/gI<Left><Left><Left>]])

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "{", "{zzzv")
vim.keymap.set("n", "}", "}zzzv")

vim.keymap.set("n", "<leader>fp", ':let @+=expand("%:.")<cr>')

vim.keymap.set("n", "<leader>if", 'oif err != nil {}<left><cr><esc>Oreturn err<esc>')

vim.keymap.set("n", "<leader>qd", ':cdo execute "norm @q" | update<cr><cr>')

vim.keymap.set("n", "<C-y>", "<C-w><C-w>")
