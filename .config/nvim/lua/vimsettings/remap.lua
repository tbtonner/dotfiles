vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<F6>", function()
    vim.o.spell = not vim.o.spell
    vim.notify("Spell Check: " .. (vim.o.spell and "On" or "Off"))
end, { desc = "Toggle spell check" })

vim.keymap.set("n", "U", "15<C-y>")
vim.keymap.set("n", "D", "15<C-e>")

vim.keymap.set("n", "<C-d>", ":close!<cr>")
vim.keymap.set("n", "<C-s>", ":silent wa | silent w<cr>")
vim.keymap.set("n", "<C-c>", ':bp | bd #<cr>')

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [["zyy:%s/<C-r>z/<C-r>z/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>fp", function()
    local filepath = vim.fn.expand("%:.")
    vim.fn.setreg("+", filepath)
    vim.notify(filepath)
end, { desc = "Copy file path" })

vim.keymap.set("n", "<leader>qd", ':cdo execute "norm @q" | update<cr><cr>')
vim.keymap.set("n", "<leader>qc", ':call setqflist([])<cr>')

vim.keymap.set("n", "]d", function()
    local qf = vim.fn.getqflist()
    local idx = vim.fn.getqflist({ idx = 0 }).idx
    table.remove(qf, idx)
    if vim.tbl_isempty(qf) then
        vim.fn.setqflist({}, "r")
        vim.cmd.cclose()
        vim.notify("Quickfix list is now empty.")
        return
    end
    vim.fn.setqflist(qf, "r")
    vim.cmd("cc " .. math.min(idx, #qf))
end, { desc = "Remove current quickfix item and go to next" })

vim.keymap.set("n", "<leader>r", function()
    local text = vim.fn.getreg("+"):gsub("\n", "")
    if text ~= "" then
        vim.cmd.normal({ args = { '"_ciw' .. text }, bang = true })
    end
end, { desc = "Replace word with clipboard" })
