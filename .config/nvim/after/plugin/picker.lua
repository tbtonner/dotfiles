local Snacks = require("snacks")

-- Drops picker items whose file path contains "mocks".
local function no_mocks(item)
    return not (item.file and item.file:find("mocks", 1, true))
end

-- Returns a callback opening the named snacks picker with the result list focused (normal mode) rather than the prompt.
local function picker(name, extra)
    local opts = vim.tbl_extend("force", { focus = "list" }, extra or {})
    return function() Snacks.picker[name](opts) end
end

-- Shows :messages newest first in a picker; confirming yanks the line.
local function messages()
    local lines = vim.split(vim.fn.execute("messages"), "\n", { trimempty = true })
    local items = {}
    for i = #lines, 1, -1 do
        items[#items + 1] = { text = lines[i], preview = { text = lines[i] } }
    end
    Snacks.picker({
        title = "Messages",
        items = items,
        format = "text",
        preview = "preview",
        focus = "list",
        confirm = { "yank", "close" },
        win = { preview = { wo = { wrap = true } } },
    })
end

-- Runs cmd in cwd and returns its trimmed stdout, or nil (with a warning) if it fails.
local function run(cmd, cwd)
    local res = vim.system(cmd, { cwd = cwd, text = true }):wait()
    if res.code ~= 0 then
        vim.notify(cmd[1] .. " failed: " .. vim.trim(res.stderr), vim.log.levels.WARN)
        return nil
    end
    return vim.trim(res.stdout)
end

-- The PR that introduced a commit. Searching PRs by SHA also matches every merge-main and branch-sync PR containing
-- it, so ask GitHub for the commit's associated PRs instead, preferring the one that merged it.
local pulls_jq = "[.[] | select(.merged_at)] + . | .[0].html_url // empty"

-- Copies the GitHub URL of the PR that introduced the line under the cursor.
local function pr_for_line()
    local file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fs.dirname(file)
    local line = vim.fn.line(".")
    local blame = run({ "git", "blame", "--porcelain", "-L", line .. "," .. line, "--", file }, cwd)
    local sha = blame and blame:match("^(%x+)")
    if not sha then return end
    if sha:match("^0+$") then
        vim.notify("Line is not committed yet", vim.log.levels.WARN)
        return
    end
    local url = run({ "gh", "api", "repos/{owner}/{repo}/commits/" .. sha .. "/pulls", "--jq", pulls_jq }, cwd)
    if not url then return end
    if url == "" then
        vim.notify("No PR found for " .. sha:sub(1, 8), vim.log.levels.WARN)
        return
    end
    vim.fn.setreg("+", url)
    vim.notify("Copied " .. url)
end

-- Closes the snacks explorer if it is open, otherwise opens it.
local function toggle_explorer()
    local open = Snacks.picker.get({ source = "explorer" })[1]
    if open then
        open:close()
        return
    end
    Snacks.explorer()
end

vim.keymap.set("n", "<F1>", toggle_explorer, { desc = "Toggle file explorer" })

vim.keymap.set("n", "<leader>gp", pr_for_line, { desc = "Copy PR link for current line" })
-- Only my PRs: snacks lists PRs with mergeStateStatus, which GitHub can't compute for 50 couchbase-cloud PRs within
-- snacks' 10s timeout (it 502s). Filtering by author keeps the result set small enough.
vim.keymap.set("n", "<leader>gP", function() Snacks.picker.gh_pr({ author = "@me", state = "all" }) end,
    { desc = "My PRs" })

vim.keymap.set("n", "<C-p>", function() Snacks.picker.files() end)
vim.keymap.set("n", "<C-f>", function() Snacks.picker.grep({ regex = false }) end)
vim.keymap.set("n", "<leader>tr", function() Snacks.picker.resume() end)

vim.keymap.set("n", "gb", picker("buffers"))
vim.keymap.set("n", "gd", picker("lsp_definitions", { transform = no_mocks }))
vim.keymap.set("n", "gi", picker("lsp_implementations", { transform = no_mocks }))
vim.keymap.set("n", "gr", picker("lsp_references", { include_declaration = false, transform = no_mocks }))
vim.keymap.set("n", "ge", picker("diagnostics", { severity = vim.diagnostic.severity.ERROR }))
vim.keymap.set("n", "gJ", picker("jumps"))

vim.keymap.set("n", "gf", picker("treesitter"))
vim.keymap.set("n", "gq", picker("qflist"))
vim.keymap.set("n", "gn", function() require("noice.integrations.snacks").open({ focus = "list" }) end)
vim.keymap.set("n", "gm", messages)
