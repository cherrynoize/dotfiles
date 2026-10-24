-- Per-project bookmarks. Plugin-owned maps: `<leader>''` (menu) and
-- `<leader>'b` (per-buffer line bookmarks, moved off the default `m` so it
-- doesn't shadow marks). Inside the menu: `v` + item opens it in a vertical
-- split, `-` + item in a horizontal one. The remaining `<leader>'` maps live
-- in core/keymaps/init.lua
return {
  "otavioschwanck/arrow.nvim",
  event = "VeryLazy",
  dependencies = "nvim-mini/mini.nvim", -- devicons stand-in, see mini.lua
  opts = {
    show_icons = true,
    leader_key = "<leader>''",
    buffer_leader_key = "<leader>'b",
    separate_by_branch = false,
  },
}
