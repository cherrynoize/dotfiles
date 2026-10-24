-- Replaces the manual `workspace.library = nvim_get_runtime_file(...)` in
-- lsp.lua: lua_ls only gets the modules a file actually `require`s
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
