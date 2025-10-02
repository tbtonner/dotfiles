require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        keymap = {
            -- <C-Tab>/<C-t> to accept
            accept = "\20",
            prev = "<C-h>",
            next = "<C-l>",
            dismiss = "<C-g>",
        },
    },
    panel = {
        enabled = false,
    },
})
