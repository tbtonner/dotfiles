-- require("copilot").setup({
--     panel = {
--         auto_refresh = false,
--         keymap = {
--             accept = "<CR>",
--             jump_prev = "[[",
--             jump_next = "]]",
--             refresh = "gr",
--             open = "<F3>",
--         },
--     },
--     suggestion = {
--         auto_trigger = true,
--         keymap = {
--             accept = "<Tab>",
--             prev = "<F7>",
--             next = "<F9>",
--             dismiss = "<C-]>",
--         },
--     },
-- })

require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
})

require("copilot_cmp").setup()
