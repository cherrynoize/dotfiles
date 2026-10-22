return {
  "akinsho/toggleterm.nvim",
  version = "*",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    on_create = function()
      vim.opt.foldcolumn = "0"
      vim.opt.signcolumn = "no"
    end,
    shading_factor = 2,
    direction = "float",
    float_opts = { border = "curved" },
  },
}
