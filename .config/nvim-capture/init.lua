-- Config for tmux capture-to-nvim.sh and $EDITOR (NVIM_APPNAME=nvim-capture).
-- Reuses plugins from the main nvim's lazy.nvim install; any that are missing are skipped.
local lazy_path = vim.fn.expand("~/.local/share/nvim/lazy/")
local plugins = {
  "baleia.nvim", "kanagawa.nvim", "nvim-surround", "nvim-various-textobjs", "flash.nvim",
  -- LSP, for when this config is $EDITOR (see config.fish)
  "nvim-lspconfig", "mason.nvim", "mason-lspconfig.nvim", "lazydev.nvim", "blink.cmp",
}
for _, plugin in ipairs(plugins) do
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

-- Same LSP setup as the main config (servers, shared gopls daemon). after/ is not on the runtimepath here, so source it
-- directly. gd/gi/gr are snacks pickers in the main config; use the built-in quickfix versions instead.
local ok_lsp, lsp_err = pcall(dofile, vim.fn.expand("~/.config/nvim/after/plugin/lsp.lua"))
if not ok_lsp then
  vim.notify("nvim-capture: LSP setup failed: " .. lsp_err, vim.log.levels.WARN)
end
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gr", vim.lsp.buf.references)

local ok_surround, surround = pcall(require, "nvim-surround")
if ok_surround then surround.setup({}) end

local ok_textobjs, textobjs = pcall(require, "various-textobjs")
if ok_textobjs then textobjs.setup({ keymaps = { useDefaults = true } }) end

local ok_flash, flash = pcall(require, "flash")
if ok_flash then
  flash.setup({})
  vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end)
end

-- Read-only scratch views, opened at the bottom: tmux captures (prefix+a, and H below) and Claude Code transcripts
-- (ctrl+o then v). Captures carry ANSI colours for baleia and stay unwrapped; transcripts are plain prose.
local function scratch_view(ansi)
  return function(ev)
    vim.cmd("setlocal buftype=nofile bufhidden=wipe noswapfile")
    if ansi then
      vim.opt_local.conceallevel = 3
      vim.opt_local.wrap = false
      local ok_baleia, baleia = pcall(require, "baleia")
      if ok_baleia then baleia.setup({}).once(ev.buf) end
    end
    vim.cmd("normal! G")
  end
end
vim.api.nvim_create_autocmd("BufReadPost", { pattern = "*/tmux-captures-*/*.txt", callback = scratch_view(true) })
vim.api.nvim_create_autocmd("BufReadPost", { pattern = "*/cc-transcript-*.txt", callback = scratch_view(false) })

-- quit, but only from those scratch views. This config is also $EDITOR (see config.fish), so in a real file such as a
-- commit message q and <Esc> keep their normal meaning.
local function quit_if_scratch(key)
  return function()
    if vim.bo.buftype == "nofile" then
      return "<cmd>q!<cr>"
    end
    return key
  end
end
vim.keymap.set("n", "q", quit_if_scratch("q"), { expr = true })
vim.keymap.set("n", "<Esc>", quit_if_scratch("<Esc>"), { expr = true })

-- error/warning highlights
vim.fn.matchadd("ErrorMsg", [[\c\(error\|failed\|fatal\|fail\)]])
vim.fn.matchadd("WarningMsg", [[\c\(warning\|warn\)]])

-- named captures history (same dir as capture-to-nvim.sh: $TMPDIR is per-user on macOS, /tmp on Linux)
local capdir = (vim.env.TMPDIR or "/tmp"):gsub("/+$", "") .. "/tmux-captures-" .. vim.uv.getuid()
vim.keymap.set("n", "H", function()
  local files = vim.fn.glob(capdir .. "/2*.txt", false, true)
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
    end
  end)
end)
