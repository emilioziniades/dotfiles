require("autocommands")

local vars = require("variables")
local utils = require("utils")

-- theme (time dependent)
vim.cmd("colorscheme " .. vars.theme)

-- other settings

vim.g.mapleader = " "

local options = {
	background = vars.background,
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

for key, value in pairs(options) do
	vim.o[key] = value
end
-- make current line number pop
utils.line_number_emphasize()
