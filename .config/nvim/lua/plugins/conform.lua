return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    notify_on_error = false,
    default_format_opts = { lsp_format = "fallback" },
    formatters_by_ft = { lua = { "stylua" } },
  },
}
