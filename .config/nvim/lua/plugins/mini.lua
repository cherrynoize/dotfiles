return {
  "nvim-mini/mini.nvim",
  lazy = false,
  config = function()
    require("mini.icons").setup()
    -- plugins such as telescope still look for nvim-web-devicons
    MiniIcons.mock_nvim_web_devicons()

    require("mini.ai").setup { n_lines = 500 }
    require("mini.bufremove").setup()
    require("mini.surround").setup {
      mappings = require("core.keymaps.surround"),
    }

    local statusline = require "mini.statusline"
    statusline.setup { use_icons = true }
    statusline.section_location = function() return "%2l:%-2v" end

    -- scrollbar + minimap, toggled with `<leader>um` / `<leader>uM`
    local map = require "mini.map"
    map.setup {
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diagnostic(),
        map.gen_integration.gitsigns(),
      },
      -- the default encoding uses sextant glyphs most fonts lack (they show
      -- up as white boxes); braille dots render almost everywhere
      symbols = { encode = map.gen_encode_symbols.dot "4x2" },
      window = { show_integration_count = false },
    }

    -- windows.nvim already animates resizes (via animation.nvim), so that
    -- one stays off here to keep the two from fighting
    local animate = require "mini.animate"
    local function total(duration)
      return animate.gen_timing.linear { duration = duration, unit = "total" }
    end
    animate.setup {
      cursor = { timing = total(100) },
      scroll = { timing = total(60) },
      resize = { enable = false },
      open = { timing = total(150) },
      close = { timing = total(150) },
    }
  end,
}
