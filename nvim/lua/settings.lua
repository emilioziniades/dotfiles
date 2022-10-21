local utils = require("utils")
local colorscheme = "tokyonight-night"

vim.cmd("colorscheme " .. colorscheme)
utils.line_number_emphasize()

local globals = {
	mapleader = " ",
}

local options = {
	mouse = "",
	undofile = true,
	wrap = true,
	linebreak = true,
	spell = false,
	spelllang = "en_gb",
	number = true,
	relativenumber = true,
	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	expandtab = true,
	foldmethod = "expr",
	foldenable = false,
	showmode = false,
	termguicolors = true,
	splitright = true,
}

utils.set_variables(globals, vim.g)
utils.set_variables(options, vim.o)
