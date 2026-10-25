-- LSP progress only; regular notifications go through nvim-notify (notify.lua)
return {
  "j-hui/fidget.nvim",
  event = "VeryLazy",
  opts = { notification = { override_vim_notify = false } },
}
