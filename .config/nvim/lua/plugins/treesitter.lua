local parsers = {
  "bash",
  "c",
  "diff",
  "html",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "query",
  "vim",
  "vimdoc",
  "fish",
  "css",
  "scss",
  "arduino",
  "cpp",
  "json",
  "yaml",
  "toml",
  "python",
  "dockerfile",
  "erlang",
  "gitignore",
  "hyprlang",
  "javascript",
  "kitty",
  "ocaml",
  "rust",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  -- the main branch does not support lazy-loading
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require "nvim-treesitter"
    treesitter.install(parsers)

    local function try_attach(buf, language)
      if not vim.treesitter.language.add(language) then return end
      vim.treesitter.start(buf, language)

      -- without an indent query indentexpr keeps Vim's built-in indenting
      if vim.treesitter.query.get(language, "indents") ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local available = treesitter.get_available()
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Start treesitter",
      group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
      callback = function(args)
        local buf = args.buf
        if vim.b[buf].large_buf then return end

        local language = vim.treesitter.language.get_lang(args.match)
        if not language then return end

        if vim.tbl_contains(treesitter.get_installed "parsers", language) then
          try_attach(buf, language)
        elseif vim.tbl_contains(available, language) then
          treesitter.install(language):await(function()
            try_attach(buf, language)
          end)
        else
          try_attach(buf, language)
        end
      end,
    })
  end,
}
