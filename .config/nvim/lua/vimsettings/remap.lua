vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<F6>", function()
    vim.o.spell = not vim.o.spell
    vim.notify("Spell Check: " .. (vim.o.spell and "On" or "Off"))
end, { desc = "Toggle spell check" })

vim.keymap.set("n", "U", "15<C-y>")
vim.keymap.set("n", "D", "15<C-e>")

vim.keymap.set("n", "<C-d>", ":q!<cr>")
vim.keymap.set("t", "<C-d>", [[<C-\><C-n>:q!<CR>]])
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

vim.keymap.set("n", "<leader>fP", function()
    local filepath = vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")
    vim.fn.setreg("+", filepath)
    vim.notify(filepath)
end, { desc = "Copy file path with line number" })

vim.keymap.set("v", "<leader>fp", function()
    local filepath = vim.fn.expand("%:.")
    local line_start = math.min(vim.fn.line("."), vim.fn.line("v"))
    local line_end = math.max(vim.fn.line("."), vim.fn.line("v"))
    local result = filepath .. ":" .. line_start .. (line_start ~= line_end and ("-" .. line_end) or "")
    vim.fn.setreg("+", result)
    vim.notify(result)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
end, { desc = "Copy file path with line range" })

vim.keymap.set("n", "<leader>qd", ':cdo execute "norm @q" | update<cr><cr>')
vim.keymap.set("n", "<leader>qc", ':call setqflist([])<cr>')

vim.keymap.set("n", "]]", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[[", function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = "Previous diagnostic" })

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

vim.api.nvim_create_user_command('E', function(opts)
    local arg = opts.args
    if arg == '' then
        vim.cmd('edit')
        return
    end
    local file, line = arg:match('^(.+):(%d+)%-?%d*$')
    if file and line then
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
        vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
    else
        vim.cmd('edit ' .. vim.fn.fnameescape(arg))
    end
end, { nargs = '*', complete = 'file' })

vim.cmd('cabbrev e E')

vim.api.nvim_create_user_command('Fresh', function(opts)
    vim.cmd('silent! %bd')
    vim.cmd('edit ' .. opts.args)
    vim.cmd('LspRestart')
    print("Buffers cleared. LSP restarted. Ready to code!")
end, { nargs = 1, complete = "file" })
