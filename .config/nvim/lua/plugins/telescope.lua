return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-mini/mini.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = vim.fn.executable "make" == 1,
    },
    "nvim-telescope/telescope-ui-select.nvim",
  },
  -- init runs at startup so the LSP pickers exist before telescope is loaded
  init = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "Telescope LSP pickers",
      group = vim.api.nvim_create_augroup("telescope-lsp-attach", {
        clear = true,
      }),
      callback = function(event)
        local function map(lhs, picker, desc)
          vim.keymap.set("n", lhs, function()
            require("telescope.builtin")[picker]()
          end, { buffer = event.buf, desc = desc })
        end
        map("<leader>l=", "lsp_definitions", "Go to definition")
        map("<leader>lt", "lsp_type_definitions", "Go to type definition")
        map("<leader>lI", "lsp_implementations", "Go to implementation")
        map("<leader>lR", "lsp_references", "Find references")
        map("<leader>ls", "lsp_document_symbols", "Document symbols")
        map("<leader>lS", "lsp_dynamic_workspace_symbols", "Workspace symbols")
      end,
    })
  end,
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      extensions = {
        ["ui-select"] = { require("telescope.themes").get_dropdown() },
      },
    }
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
}
