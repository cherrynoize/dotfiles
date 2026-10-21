return {
  "nvim-mini/mini.nvim",
  lazy = false,
  config = function()
    require("mini.icons").setup()
    -- plugins such as telescope still look for nvim-web-devicons
    MiniIcons.mock_nvim_web_devicons()

    require("mini.ai").setup { n_lines = 500 }
    require("mini.surround").setup {
      mappings = require("core.keymaps.surround"),
    }

    local statusline = require "mini.statusline"
    statusline.setup { use_icons = true }
    statusline.section_location = function() return "%2l:%-2v" end
  end,
}
