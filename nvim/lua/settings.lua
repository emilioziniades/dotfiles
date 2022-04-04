local vars = require("variables")
local utils = require("utils")

-- theme (time dependent)
vim.g.tokyonight_dark_float = true
vim.cmd("colorscheme " .. vars.theme)
vim.o.background = vars.background

-- other settings

vim.g.mapleader = " "

vim.g.AutoPairs = {
	["("] = ")",
	["["] = "]",
	["{"] = "}",
	["'"] = "'",
	['"'] = '"',
	["`"] = "`",
	["__"] = "__",
}

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
-- vim.o.showmode = false
vim.o.showmode = true
vim.o.termguicolors = true

-- make current line number pop
utils.line_number_emphasize()

-- filetype specific settings

vim.cmd([[autocmd BufRead,BufNewFile *.js,*.jsx setlocal tabstop=2 shiftwidth=2 ]])
vim.cmd([[autocmd BufRead,BufNewFile *.js,*.jsx lua vim.g.AutoPairs["<"] = ">" ]])

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
