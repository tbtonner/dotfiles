local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
