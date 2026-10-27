-- kind icons from mini.icons; the path source gets file/folder icons
local function mini_icon(ctx)
  local category, name = "lsp", ctx.kind
  if ctx.source_name == "Path" then
    category = ctx.kind == "Folder" and "directory" or "file"
    name = ctx.label
  end
  return require("mini.icons").get(category, name)
end

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
        ["<C-e>"] = false,
        ["<C-BS>"] = { "hide", "fallback" }, -- close menu
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        -- lsp-zero (nvim-cmp) look: bordered windows, icon | label | [source]
        menu = {
          border = "rounded",
          min_width = 30,
          draw = {
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
            components = {
              kind_icon = {
                text = function(ctx)
                  local icon = mini_icon(ctx)
                  return icon .. ctx.icon_gap
                end,
                highlight = function(ctx)
                  local _, hl = mini_icon(ctx)
                  return hl
                end,
              },
              source_name = {
                text = function(ctx) return "[" .. ctx.source_name .. "]" end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = "rounded" },
        },
      },
      sources = {
        default = { "lsp", "path" },
        per_filetype = {
          lua = { inherit_defaults = true, "lazydev" },
        },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- above the LSP results
          },
        },
      },
      fuzzy = { implementation = "lua" },
      signature = { enabled = true, window = { border = "rounded" } },
    },
  },
}
