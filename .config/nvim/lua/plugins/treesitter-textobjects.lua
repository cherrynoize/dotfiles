return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  -- loaded on first require by the maps in core/keymaps
  lazy = true,
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = { move = { set_jumps = true } },
}
