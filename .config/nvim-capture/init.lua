-- Config for tmux capture-to-nvim.sh (NVIM_APPNAME=nvim-capture).
-- Reuses plugins from the main nvim's lazy.nvim install; any that are missing are skipped.
local lazy_path = vim.fn.expand("~/.local/share/nvim/lazy/")
for _, plugin in ipairs({ "baleia.nvim", "kanagawa.nvim", "nvim-surround", "nvim-various-textobjs", "flash.nvim" }) do
  if vim.fn.isdirectory(lazy_path .. plugin) == 1 then
    vim.opt.runtimepath:append(lazy_path .. plugin)
  end
end
vim.opt.runtimepath:append(vim.fn.expand("~/.config/nvim"))

if not pcall(require, "vimsettings.set") then
  vim.opt.termguicolors = true
  vim.opt.clipboard = "unnamedplus"
end
pcall(require, "vimsettings.remap")

pcall(vim.cmd.colorscheme, "kanagawa")

local ok_surround, surround = pcall(require, "nvim-surround")
if ok_surround then surround.setup({}) end

local ok_textobjs, textobjs = pcall(require, "various-textobjs")
if ok_textobjs then textobjs.setup({ keymaps = { useDefaults = true } }) end

local ok_flash, flash = pcall(require, "flash")
if ok_flash then
  flash.setup({})
  vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end)
end

-- quit
vim.keymap.set("n", "q", "<cmd>q!<cr>")

-- error/warning highlights
vim.fn.matchadd("ErrorMsg", [[\c\(error\|failed\|fatal\|fail\)]])
vim.fn.matchadd("WarningMsg", [[\c\(warning\|warn\)]])

-- named captures history
vim.keymap.set("n", "H", function()
  local files = vim.fn.glob("/tmp/tmux-captures/*.txt", false, true)
  if vim.tbl_isempty(files) then
    vim.notify("No saved captures")
    return
  end
  table.sort(files, function(a, b) return a > b end)
  local items = {}
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")
    local y, mo, d, h, mi, s = name:match("(%d%d%d%d)(%d%d)(%d%d)_(%d%d)(%d%d)(%d%d)")
    if y then
      table.insert(items, { label = string.format("%s-%s-%s %s:%s:%s", y, mo, d, h, mi, s), file = f })
    end
  end
  vim.ui.select(items, {
    prompt = "Captures",
    format_item = function(item) return item.label end,
  }, function(item)
    if item then
      vim.cmd("e " .. item.file)
      vim.cmd("normal! G")
      local ok_baleia, baleia = pcall(require, "baleia")
      if ok_baleia then baleia.setup({}).once(0) end
    end
  end)
end)
