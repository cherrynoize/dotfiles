return {
  "catgoose/nvim-colorizer.lua",
  main = "colorizer",
  event = "BufReadPre",
  cmd = "ColorizerToggle",
  opts = {
    filetypes = {
      "*",
      sass = { parsers = { sass = { enable = true, parsers = { css = true } } } },
      scss = { parsers = { sass = { enable = true, parsers = { css = true } } } },
    },
    options = {
      parsers = {
        names = { enable = true },
        hex = { default = true, rrggbbaa = true, aarrggbb = false },
        rgb = { enable = true },
        hsl = { enable = true },
        sass = { enable = false },
      },
    },
  },
}
