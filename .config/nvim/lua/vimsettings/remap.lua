vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<F6>", function()
    vim.o.spell = not vim.o.spell
    vim.notify("Spell Check: " .. (vim.o.spell and "On" or "Off"))
end, { desc = "Toggle spell check" })

-- C-hjkl move between nvim splits, then hand over to tmux at the edge. The tmux side lives in
-- ~/.config/tmux/navigate.sh, which falls through to the next window or session at the edge of the tmux window.
local function navigate(wincmd, tmux_dir)
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(wincmd)
    if vim.api.nvim_get_current_win() ~= win or not vim.env.TMUX then
        return
    end
    vim.system({ vim.fn.expand("~/.config/tmux/navigate.sh"), tmux_dir, vim.env.TMUX_PANE })
end

for key, dirs in pairs({ h = { "h", "L" }, j = { "j", "D" }, k = { "k", "U" }, l = { "l", "R" } }) do
    vim.keymap.set("n", "<C-" .. key .. ">", function() navigate(dirs[1], dirs[2]) end,
        { desc = "Move to split, tmux pane, window or session" })
end

vim.keymap.set("n", "U", "15<C-y>")
vim.keymap.set("n", "D", "15<C-e>")

vim.keymap.set("n", "<C-d>", ":q<cr>")
vim.keymap.set("t", "<C-d>", [[<C-\><C-n>:q!<cr>]])
vim.keymap.set("n", "<C-s>", ":silent wa | silent w<cr>")
vim.keymap.set("n", "<C-c>", ':bp | bd #<cr>')

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", function()
    vim.cmd('normal! "zy')
    local text = vim.fn.getreg("z")
    local search = "\\V" .. vim.fn.escape(text, "/\\")
    local replace = vim.fn.escape(text, "/\\&~")
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<Esc>:%s/" .. search .. "/" .. replace .. "/gI<Left><Left><Left>", true, false, true),
        "n", false
    )
end, { desc = "Substitute visual selection" })

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

-- :restart stops the old server with :qall, then reattaches the UI to a fresh one. When :qall refuses -- an unnamed
-- modified buffer -- the reattach still happens and the old server is left running headless, holding its swapfiles.
-- See the "dangling server process" note in :h :restart. Write everything first so :qall cannot refuse.
local function blocks_qall(buf)
    if not vim.api.nvim_buf_is_loaded(buf) or not vim.bo[buf].modified then
        return false
    end
    return vim.bo[buf].buftype == "" and vim.api.nvim_buf_get_name(buf) == ""
end

local function restart_cleanly()
    local blocked = vim.tbl_filter(blocks_qall, vim.api.nvim_list_bufs())
    if #blocked > 0 then
        vim.notify(("Restart aborted: %d unnamed modified buffer(s)"):format(#blocked), vim.log.levels.WARN)
        return
    end
    local ok, err = pcall(vim.cmd, "wall")
    if not ok then
        vim.notify("Restart aborted, :wall failed: " .. err, vim.log.levels.ERROR)
        return
    end
    vim.cmd("restart")
end

-- ZR is a built-in in 0.12, next to ZZ/ZQ, and [count]ZR is ":restart +qall!" which discards changes. Shadow it.
vim.keymap.set("n", "ZR", restart_cleanly, { desc = "Write all buffers, then restart" })

vim.keymap.set("n", "]]", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[[", function() vim.diagnostic.jump({ count = -1, float = true }) end,
    { desc = "Previous diagnostic" })

vim.keymap.set("n", "]g", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git hunk" })
vim.keymap.set("n", "[g", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous git hunk" })

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
    if arg:match('github%.com/') then
        local gh_file = arg:match('/blob/[^/]+/([^#]+)')
        if gh_file then
            vim.cmd('edit ' .. vim.fn.fnameescape(gh_file))
            local gh_line = arg:match('#L(%d+)')
            if gh_line then
                vim.api.nvim_win_set_cursor(0, { tonumber(gh_line), 0 })
            end
            return
        end
    end
    local file, line = arg:match('^(.+):(%d+)%-?%d*$')
    if file and line then
        vim.cmd('edit ' .. vim.fn.fnameescape(file))
        vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
    else
        vim.cmd('edit ' .. vim.fn.fnameescape(arg))
    end
end, {
    nargs = '*',
    complete = function(arglead)
        return vim.fn.getcompletion(arglead, 'file')
    end,
})

vim.cmd('cabbrev e E')

vim.api.nvim_create_user_command('Fresh', function(opts)
    vim.cmd('silent! %bd')
    vim.cmd('edit ' .. opts.args)
    vim.cmd('LspRestart')
    print("Buffers cleared. LSP restarted. Ready to code!")
end, { nargs = 1, complete = "file" })
