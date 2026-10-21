vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.loader.enable()

require "core.options"
require "core.lazy"
require "core.keymaps"
require "core.autocmds"

vim.cmd.colorscheme(require "core.colorscheme")
