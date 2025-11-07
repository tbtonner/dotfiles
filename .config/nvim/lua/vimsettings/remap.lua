vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<F6>", ':set spell!<CR><Bar>:echo "Spell Check: " . strpart("OffOn", 3 * &spell, 3)<cr>')

vim.keymap.set("n", "<C-d>", ":close!<cr>")
vim.keymap.set("n", "<C-s>", ":silent wa | silent w<cr>")
vim.keymap.set("n", "<C-c>", ':bp | bd #<cr>')

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [["qyy:%s/<C-r>q/<C-r>q/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>fp", ':let @+=expand("%:.")<cr>')

vim.keymap.set("n", "<leader>if", 'oif err != nil {}<left><cr><esc>Oreturn err<esc>')

vim.keymap.set("n", "<C-y>", "<C-w><C-w>")

vim.keymap.set("n", "<leader>qd", ':cdo execute "norm @q" | update<cr><cr>')
vim.keymap.set("n", "<leader>qc", ':call setqflist([])<cr>')
vim.keymap.set("n", "]d", function()
    local qflist = vim.fn.getqflist()
    local current = vim.fn.getqflist({ idx = 0 }).idx

    table.remove(qflist, current)

    if #qflist == 0 then
        vim.fn.setqflist({}, 'r')
        vim.cmd("cclose")
        print("Quickfix list is now empty.")
        return
    end

    vim.fn.setqflist(qflist, 'r')
    local next_idx = math.min(current, #qflist)
    vim.cmd("cc " .. next_idx)
end, { desc = "Remove current quickfix item and go to next" })

vim.keymap.set("n", "<leader>r", function()
    local yanked = vim.fn.getreg("+"):gsub("\n", "")
    if yanked == "" then return end
    vim.cmd('normal! "_ciw' .. yanked)
end)
