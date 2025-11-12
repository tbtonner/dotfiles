local notify_consumer = function(client)
    client.listeners.run = function(_, _, position_ids)
        vim.schedule(function()
            if position_ids and #position_ids == 1 then
                local name = position_ids[1]:match("::(.+)$")
                    or position_ids[1]:match(".+/([^/]+)$")
                    or position_ids[1]
                vim.notify("Running " .. name .. "...", vim.log.levels.INFO, { title = "Neotest" })
            else
                vim.notify("Running tests...", vim.log.levels.INFO, { title = "Neotest" })
            end
        end)
    end


    client.listeners.results = function(_, results, partial)
        if partial then return end

        local passed, failed = {}, {}
        local test_count = 0

        for test_id, result in pairs(results) do
            if test_id:match("::") then
                test_count = test_count + 1
                local test_name = test_id:match("::(.+)$") or test_id
                if result.status == "passed" then
                    table.insert(passed, test_name)
                elseif result.status == "failed" then
                    table.insert(failed, test_name)
                else
                    table.insert(passed, test_name .. " (" .. (result.status or "unknown") .. ")")
                end
            end
        end

        vim.schedule(function()
            if test_count == 1 then
                local name = passed[1] or failed[1]
                local status = #failed > 0 and "failed" or "passed"
                vim.notify(name .. ": " .. status, #failed > 0 and vim.log.levels.ERROR or vim.log.levels.INFO,
                    { title = "Neotest" })
            elseif test_count > 1 then
                if #failed == 0 then
                    vim.notify("All tests passed!", vim.log.levels.INFO, { title = "Neotest" })
                else
                    local msg = string.format("%d test(s) failed: %s", #failed, table.concat(failed, ", "))
                    vim.notify(msg, vim.log.levels.ERROR, { title = "Neotest" })
                end
            end
        end)
    end
end

require("neotest").setup({
    adapters = {
        require('neotest-golang')({
            runner = "gotestsum",
            go_test_args = {
                "-v",
                "-count=1",
            },
            warn_test_name_dupes = false,
        })
    },
    consumers = {
        notify = notify_consumer,
    },
    quickfix = {
        enabled = false,
    },
    discovery = { enabled = false },
})

vim.keymap.set('n', '<Leader>tn', ':lua require("neotest").run.run()<CR>', { desc = 'Run test' })
vim.keymap.set('n', '<Leader>tf', ':lua require("neotest").run.run(vim.fn.expand("%"))<CR>', { desc = 'Run file' })
vim.keymap.set('n', '<Leader>td', ':lua require("neotest").run.run(vim.fn.expand("%:p:h"))<CR>', { desc = 'Run dir' })
vim.keymap.set('n', '<Leader>tt', ':lua require("neotest").output.open({ enter = true, auto_close = true })<CR>',
    { desc = 'Show test result' })
