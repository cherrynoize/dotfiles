return {
  "catgoose/nvim-colorizer.lua",
  main = "colorizer",
  event = "BufReadPre",
  opts = {
    options = {
      parsers = {
        names = { enable = true },
        hex = { default = true, rrggbbaa = true, aarrggbb = false },
        rgb = { enable = true },
        hsl = { enable = true },
        sass = { enable = true, parsers = { css = true } },
      },
    },
  },
}
