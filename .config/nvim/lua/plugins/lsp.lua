local servers = {
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if
          path ~= vim.fn.stdpath "config"
          and (
            vim.uv.fs_stat(path .. "/.luarc.json")
            or vim.uv.fs_stat(path .. "/.luarc.jsonc")
          )
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend(
        "force",
        client.config.settings.Lua,
        {
          runtime = {
            version = "LuaJIT",
            path = { "lua/?.lua", "lua/?/init.lua" },
          },
          -- the library is managed by lazydev.nvim (plugins/lazydev.lua)
          workspace = { checkThirdParty = false },
        }
      )
    end,
    settings = { Lua = { format = { enable = false } } },
  },
  arduino_language_server = {},
  cssls = {},
}

-- LSP definition when some attached server finds one, otherwise Vim's builtin
-- `gd` (local declaration search). Asks first because
-- vim.lsp.buf.definition() only notifies when there is nothing to jump to
local function goto_definition(buf)
  vim.lsp.buf_request_all(buf, "textDocument/definition", function(client)
    return vim.lsp.util.make_position_params(0, client.offset_encoding)
  end, function(results)
    for _, response in pairs(results) do
      local result = response.result
      -- a single Location is a dict, several are a list
      if result and (not vim.islist(result) or #result > 0) then
        vim.lsp.buf.definition()
        return
      end
    end
    local ok, err = pcall(vim.cmd, "normal! gd")
    if not ok then vim.notify(err, vim.log.levels.WARN) end
  end)
end

return {
  "neovim/nvim-lspconfig",
  -- lazy = false: mason-tool-installer misses its VimEnter trigger when loaded
  -- later (WhoIsSethDaniel/mason-tool-installer.nvim#39)
  lazy = false,
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    { "mason-org/mason-lspconfig.nvim", opts = { automatic_enable = false } },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = vim.list_extend(vim.tbl_keys(servers), { "stylua" }),
      },
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP maps and reference highlighting",
      group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
      callback = function(event)
        local function map(lhs, rhs, desc, mode)
          vim.keymap.set(
            mode or "n",
            lhs,
            rhs,
            { buffer = event.buf, desc = "LSP: " .. desc }
          )
        end
        map("grn", vim.lsp.buf.rename, "Rename symbol")
        map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("<leader>la", vim.lsp.buf.code_action, "Code action", { "n", "x" })
        map("<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>lh", vim.lsp.buf.signature_help, "Signature help")

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        local function supports(method)
          return client and client:supports_method(method, event.buf)
        end

        -- without an LSP definition provider no map is set, so Vim's builtin
        -- `gd` stays in effect; with one, it still falls back when the
        -- server finds nothing
        if supports "textDocument/definition" then
          map("gd", function() goto_definition(event.buf) end, "Go to definition")
        end

        if supports "textDocument/documentHighlight" then
          local highlight = vim.api.nvim_create_augroup("lsp-highlight", {
            clear = false,
          })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
            callback = function(detach)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds {
                group = "lsp-highlight",
                buffer = detach.buf,
              }
            end,
          })
        end

        if supports "textDocument/inlayHint" then
          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(
              not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf },
              { bufnr = event.buf }
            )
          end, "Toggle inlay hints (buffer)")
          map("<leader>uH", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "Toggle inlay hints (global)")
        end

        if supports "textDocument/semanticTokens/full" then
          map("<leader>uY", function()
            local filter = { bufnr = event.buf }
            vim.lsp.semantic_tokens.enable(
              not vim.lsp.semantic_tokens.is_enabled(filter),
              filter
            )
          end, "Toggle semantic highlighting (buffer)")
        end

        if supports "textDocument/codeLens" then
          map("<leader>ll", vim.lsp.codelens.refresh, "Refresh CodeLens")
          map("<leader>lL", vim.lsp.codelens.run, "Run CodeLens")
        end
      end,
    })

    for name, server in pairs(servers) do
      vim.lsp.config(name, server)
      vim.lsp.enable(name)
    end
  end,
}
