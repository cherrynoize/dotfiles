-- Detects the project root (LSP root or .git and friends) and chdirs to it
-- (auto-cd on). Picker: `<leader>fp` (Telescope extension, see telescope.lua).
-- Not lazy so the first buffer opened at startup is already handled.
return {
  "DrKJeff16/project.nvim",
  lazy = false,
  opts = {},
}
