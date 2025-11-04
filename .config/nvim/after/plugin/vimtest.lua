vim.keymap.set("n", "<leader>tn", ':TestNearest<cr>', { silent = true })
vim.keymap.set("n", "<leader>tf", ':TestFile<cr>', { silent = true })
vim.keymap.set("n", "<leader>ts", ':TestSuite<cr>', { silent = true })
vim.keymap.set("n", "<leader>tl", ':TestLast<cr>', { silent = true })
vim.keymap.set("n", "<leader>tv", ':TestVisit<cr>', { silent = true })

vim.g['test#go#gotest#options'] = '--count 1'

vim.cmd("let test#strategy = 'vimux'")
