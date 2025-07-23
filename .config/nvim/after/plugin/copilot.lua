require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<C-l>",
            prev = "<C-k>",
            next = "<C-j>",
            dismiss = "<C-h>",
        },
    },
    panel = {
        enabled = false,
    },
})
