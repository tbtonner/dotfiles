-- Claude Code transcript dumps (ctrl+o then v). Linux writes them to /tmp/claude-<uid>/, macOS under $TMPDIR.
vim.filetype.add({
  pattern = {
    [".*/cc%-transcript%-%d+%.txt"] = "cctranscript",
  },
})
