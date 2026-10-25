-- Opened/closed with `<leader>gd`, file history with `<leader>gD` (see
-- core/keymaps/init.lua). Independent from fugitive. Inside diffview's own
-- panels its default maps apply, notably `<leader>e` and `<leader>b`, which
-- shadow the explorer/buffer maps in those buffers only.
return {
  "sindrets/diffview.nvim",
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
    "DiffviewRefresh",
    "DiffviewFileHistory",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-mini/mini.nvim", -- devicons stand-in, see mini.lua
  },
  opts = { enhanced_diff_hl = true },
}
