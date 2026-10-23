return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      -- toggle function
      enabled = function()
        return vim.g.completion_enabled ~= false
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end,
      keymap = {
        preset = "default",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-CR>"] = { "accept", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 1 },
      },
      sources = { default = { "lsp", "path" } },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true },
    },
  },
}
