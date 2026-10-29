-- Same body as the iferr snippet in snippets/go.json.
local iferr = "if err != nil {\n\treturn ${1:err}\n}"

vim.keymap.set("n", "<leader>if", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local indent = vim.api.nvim_get_current_line():match("^(%s*)")
    vim.api.nvim_buf_set_lines(0, row, row, false, { indent })
    vim.api.nvim_win_set_cursor(0, { row + 1, #indent })
    vim.cmd("startinsert!")
    vim.schedule(function() vim.snippet.expand(iferr) end)
end, { buffer = true, desc = "Insert if err != nil block" })
