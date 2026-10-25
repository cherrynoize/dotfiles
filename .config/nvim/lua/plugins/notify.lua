-- Popup notifications. fidget stays in charge of LSP progress only, see
-- fidget.lua; history is on `<leader>fN`.
return {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require "notify"
    notify.setup {
      -- needed with a transparent background, see core/transparency.lua
      background_colour = "#000000",
      timeout = 3000,
      render = "wrapped-compact",
      max_width = function() return math.floor(vim.o.columns * 0.4) end,
      max_height = function() return math.floor(vim.o.lines * 0.4) end,
    }
    -- honour the `<leader>uN` toggle
    vim.notify = function(msg, level, opts)
      if vim.g.notifications_suppressed then return end
      return notify(msg, level, opts)
    end
  end,
}
