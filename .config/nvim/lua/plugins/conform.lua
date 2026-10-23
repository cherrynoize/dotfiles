return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  opts = {
    notify_on_error = false,
    default_format_opts = { lsp_format = "fallback" },
    -- off by default; toggled with <leader>uF
    format_on_save = function()
      if not vim.g.format_on_save then return end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    formatters_by_ft = { lua = { "stylua" } },
  },
}
