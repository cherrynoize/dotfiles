local function close(buf) require("mini.bufremove").delete(buf, false) end

return {
  "akinsho/bufferline.nvim",
  version = "*",
  event = "VeryLazy",
  dependencies = "nvim-mini/mini.nvim",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      separator_style = "thin",
      show_close_icon = false,
      close_command = close,
      right_mouse_command = close,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          highlight = "Directory",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
}
