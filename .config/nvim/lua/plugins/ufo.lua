return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = "kevinhwang91/promise-async",
  init = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldenable = true
  end,
  opts = {
    provider_selector = function() return { "treesitter", "indent" } end,
  },
}
