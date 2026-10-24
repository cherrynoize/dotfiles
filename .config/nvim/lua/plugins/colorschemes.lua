return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- NOTE: transparency is handled by core/transparency.lua (any colorscheme);
    -- these would keep tokyonight transparent even in the opaque state.
    -- Only resort to these if you run into issues with transparency.
    --
    -- transparent = true,
    -- styles = { sidebars = "transparent", floats = "transparent" },
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
}
