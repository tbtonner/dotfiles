require("copilot").setup({
    suggestion = {
        auto_trigger = true,
        keymap = {
            -- <C-Tab> will also work with my alacritty binding the two here
            accept = "<C-t>",
            prev = "<C-h>",
            next = "<C-l>",
            dismiss = "<C-g>",
        },
    },
    panel = {
        enabled = false,
    },
})
