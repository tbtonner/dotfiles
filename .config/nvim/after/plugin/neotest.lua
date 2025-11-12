local notify_consumer = function(client)
    local function read_output(result)
        local output = result.output
        if not output then return "" end
        if type(output) == "string" then
            local f = io.open(output, "r")
            if f then
                output = f:read("*a"); f:close()
            end
        end
        return output:gsub("\27%[[0-9;]*m", "")
    end

    client.listeners.run = function(_, _, position_ids)
        vim.schedule(function()
            local msg = "Running tests..."
            if position_ids and #position_ids == 1 then
                local name = position_ids[1]:match("::(.+)$") or position_ids[1]:match(".+/([^/]+)$") or position_ids[1]
                msg = "Running " .. name .. "..."
            end
            vim.notify(msg, vim.log.levels.INFO, { title = "Neotest" })
        end)
    end

    client.listeners.results = function(_, results, partial)
        if partial then return end

        local failure_statuses = { failed = true, failure = true, error = true }
        local grouped_failures = {}

        for test_id, result in pairs(results) do
            if test_id:match("::") then
                local top_test = test_id:match("^(.-)::") or test_id
                if failure_statuses[result.status] then
                    grouped_failures[top_test] = grouped_failures[top_test] or {}
                    table.insert(grouped_failures[top_test], result)
                end
            end
        end

        vim.schedule(function()
            if next(grouped_failures) then
                for top_test, fails in pairs(grouped_failures) do
                    local combined = table.concat(
                        vim.tbl_map(function(f) return read_output(f) end, fails),
                        "\n\n"
                    )
                    vim.notify(combined, vim.log.levels.ERROR, { title = "Neotest Failure: " .. top_test })
                end
                return
            end

            vim.notify("All tests passed!", vim.log.levels.INFO, { title = "Neotest" })
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
