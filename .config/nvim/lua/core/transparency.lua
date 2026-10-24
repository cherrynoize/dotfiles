-- Colorscheme-agnostic transparent background. While `vim.g.transparent_bg`
-- is on, every ColorScheme event strips the bg from the groups below (only
-- those that actually have one). Turning it off just re-applies the current
-- colorscheme, which restores its own opaque background
local M = {}

local groups = {
  "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle",
  "FloatFooter", "SignColumn", "FoldColumn", "LineNr", "LineNrAbove",
  "LineNrBelow", "CursorLineNr", "CursorLineSign", "CursorLineFold",
  "EndOfBuffer", "MsgArea", "StatusLine", "StatusLineNC", "WinBar",
  "WinBarNC", "TabLine", "TabLineFill", "WinSeparator",
  -- neo-tree
  "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
  "NeoTreeFloatNormal", "NeoTreeFloatBorder",
  -- telescope
  "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
  "TelescopePromptBorder", "TelescopeResultsNormal",
  "TelescopeResultsBorder", "TelescopePreviewNormal",
  "TelescopePreviewBorder",
}

if vim.g.transparent_bg == nil then vim.g.transparent_bg = true end

local function clear_bg()
  for _, name in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if hl.bg or hl.ctermbg then
      hl.bg, hl.ctermbg = nil, nil
      vim.api.nvim_set_hl(0, name, hl --[[@as vim.api.keyset.highlight]])
    end
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Strip backgrounds while transparency is on",
  group = vim.api.nvim_create_augroup("transparent-bg", { clear = true }),
  callback = function()
    if vim.g.transparent_bg then clear_bg() end
  end,
})

function M.toggle()
  vim.g.transparent_bg = not vim.g.transparent_bg
  vim.cmd.colorscheme(vim.g.colors_name or require "core.colorscheme")
  vim.notify(
    "Transparent background " .. (vim.g.transparent_bg and "enabled" or "disabled")
  )
end

return M
