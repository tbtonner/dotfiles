require("lazydev").setup({})
require('mason').setup({})
require('mason-lspconfig').setup({
    automatic_enable = true,
})

vim.lsp.config("*", {
    capabilities = require('blink.cmp').get_lsp_capabilities(),
})

-- Run gopls as a shared daemon so NeoVim and other gopls clients (e.g. Claude Code) reuse one process instead of
-- spawning one each. The daemon address is derived from the gopls binary, so clients must agree on the same path -
-- hence the absolute mason path rather than whatever `gopls` $PATH happens to resolve to.
--
-- Plain `-remote=auto` resolves to a *single* socket per (binary, user), so every checkout lands in the same daemon
-- and two NeoVim instances on different branches end up fighting over it. `-remote=auto;<id>` keeps the autostart
-- and -remote.listen.timeout behaviour but gives the daemon its own socket, so the id is keyed on the workspace
-- root: the main checkout keeps the plain `auto` socket, any other checkout/worktree gets a daemon of its own, and
-- several NeoVim instances in the same checkout still share one.
--
-- Override per-invocation with $GOPLS_REMOTE: an explicit id to pick a daemon, or "off" for a private gopls with no
-- daemon at all. `:GoplsDaemon` shows what the current instance resolved to.
--
-- https://github.com/golang/tools/blob/master/gopls/doc/daemon.md
--
-- Claude Code's gopls-lsp plugin runs plain `gopls`, which resolves to ~/bin/gopls - a wrapper applying this same
-- logic so Claude joins these daemons. Keep it in sync with gopls_cmd() below.
local gopls_bin = vim.fn.expand("$HOME/.local/share/nvim/mason/bin/gopls")
local gopls_shared_root = vim.fn.resolve(vim.fn.expand("$HOME/work/couchbase-cloud"))

local function gopls_cmd()
    local override = vim.env.GOPLS_REMOTE
    if override == "" then
        override = nil
    end
    if override == "off" then
        return { gopls_bin }
    end

    local id = override
    if not id then
        local cwd = vim.fn.getcwd()
        local root = vim.fs.root(cwd, { "go.work", "go.mod", ".git" }) or cwd
        if vim.fn.resolve(root) ~= gopls_shared_root then
            id = vim.fn.sha256(vim.fn.resolve(root)):sub(1, 8)
        end
    end

    return {
        gopls_bin,
        id and ("-remote=auto;" .. id) or "-remote=auto",
        "-remote.listen.timeout=1h",
    }
end

vim.api.nvim_create_user_command("GoplsDaemon", function()
    print(table.concat(gopls_cmd(), " "))
end, { desc = "Show the gopls command (and daemon) this NeoVim instance uses" })

vim.lsp.config("gopls", {
    cmd = gopls_cmd(),
    settings = {
        gopls = {
            env = { GOFLAGS = "-tags=integration" },
            directoryFilters = {
                "-bazel-bin", "-bazel-out", "-bazel-testlogs",
                "-bazel-couchbase-cloud", "-bazel-cache",
                "-node_modules", "-.git",
                "-cmd/cp-ui-v2", "-cmd/cp-ui-v3", "-cmd/base-ui", "-cmd/fm-ui-v2",
            },
            symbolMatcher = "fastfuzzy",
            completeUnimported = true,
            usePlaceholders = false,
            semanticTokens = false,
        },
    },
})

vim.diagnostic.config({ virtual_text = true })

local opts = { silent = true }
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
