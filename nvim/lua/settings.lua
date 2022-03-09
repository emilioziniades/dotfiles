local vars = require("variables")

-- theme (time dependent)
vim.g.nord_italic = false
vim.g.nord_borders = true
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
	-- ["<"] = ">",
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

local line_num_colour
if vim.o.background == "light" then
	line_num_colour = "Black"
else
	line_num_colour = "White"
end

vim.o.cursorline = true
vim.cmd("hi Cursorline guibg=none")
vim.cmd("hi CursorLineNr term=bold ctermfg=" .. line_num_colour .. " gui=bold guifg=" .. line_num_colour)

-- filetype specific settings

vim.cmd("autocmd BufRead,BufNewFile *.js,*.jsx setlocal tabstop=2 shiftwidth=2 ")

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
