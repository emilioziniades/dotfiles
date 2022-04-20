require("autocommands")

local vars = require("variables")
local utils = require("utils")

-- theme (time dependent)
vim.g.tokyonight_dark_float = true
vim.cmd("colorscheme " .. vars.theme)
vim.o.background = vars.background

-- other settings

vim.g.mapleader = " "

vim.o.mouse = "a"
vim.opt.undofile = true
vim.o.wrap = true
vim.o.linebreak = true
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.foldmethod = "expr"
vim.o.foldenable = false
vim.o.showmode = false
vim.o.termguicolors = true
vim.o.splitright = true

-- make current line number pop
utils.line_number_emphasize()
