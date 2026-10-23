vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.loader.enable()
require "core"
vim.cmd.colorscheme(require "core.colorscheme")
