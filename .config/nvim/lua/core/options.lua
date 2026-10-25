vim.o.shell = "fish"

vim.o.nu = true
vim.o.relativenumber = true

vim.o.cursorline = true
vim.o.colorcolumn = "80"
vim.o.scrolloff = 10
vim.o.signcolumn = "yes"

vim.o.laststatus = 3
vim.o.cmdheight = 0
vim.o.updatetime = 1000

vim.opt.fillchars:append { eob = " " }
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.mouse = "a"
vim.o.keymodel = "startsel,stopsel"
vim.o.timeoutlen = 500
vim.o.virtualedit = "block"
vim.o.backspace = "indent,eol,start,nostop"
vim.o.whichwrap = vim.o.whichwrap .. ",<,>,[,]"
vim.opt.cpoptions:remove "_"
vim.o.confirm = true
vim.o.undofile = true
vim.o.clipboard = "unnamedplus"

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.hlsearch = true
vim.o.inccommand = "split"

vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.autoindent = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.winwidth = 10
vim.o.winminwidth = 10
vim.o.equalalways = false

-- vim.o.winborder = "rounded" -- show rounded corner borders on all floating windows

vim.o.completeopt = "menu,menuone,noselect"
vim.o.diffopt = vim.o.diffopt .. ",algorithm:histogram,linematch:60"

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevelstart = 99

vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
  virtual_lines = false,
  float = { border = "rounded", source = "if_many" },
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      }
    end,
  },
}
