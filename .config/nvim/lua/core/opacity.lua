local function set_bg()
  local groups = {
    "Normal", "NormalFloat", "NormalNC", "SignColumn", "FoldColumn",
    "LineNr", "LineNrAbove", "LineNrBelow", "CursorLineNr",
    "CursorLineSign", "CursorLineFold", "EndOfBuffer",
  }
  for _, name in ipairs(groups) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.bg = nil
    hl.ctermbg = nil
    vim.api.nvim_set_hl(0, name, hl)
  end

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("set-bg", { clear = true }),
  callback = set_bg,
})
