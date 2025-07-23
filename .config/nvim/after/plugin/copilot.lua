require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        keymap = {
            accept = "<C-L>",
            prev = "<C-K>",
            next = "<C-J>",
            dismiss = "<C-H>",
        },
    },
    panel = {
        enabled = false,
    },
})
