require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<Tab>",
            prev = "<C-h>",
            next = "<C-l>",
            dismiss = "<C-g>",
        },
    },
    panel = {
        enabled = false,
    },
})
