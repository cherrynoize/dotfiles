return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  init = function()
    -- move focus into the tree when it opens
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
