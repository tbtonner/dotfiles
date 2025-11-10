local flash = require("flash")

flash.setup({
    search = {
        mode = function(str)
            return "\\<" .. vim.pesc(str)
        end,
    },
})

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump)
