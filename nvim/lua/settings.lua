vars = require("variables")

-- theme (time dependent)

vim.cmd("colorscheme " .. vars.theme)
vim.o.background = vars.background

-- other settings

vim.g.mapleader = " "

vim.o.wrap = true
vim.o.linebreak = true
vim.o.spell = false
vim.o.spelllang = "en_gb"
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.foldmethod = "expr"
vim.o.foldenable = false
vim.o.showmode = false
vim.o.termguicolors = true

-- filetype specific settings

vim.cmd("autocmd BufRead,BufNewFile *.js,*.jsx setlocal tabstop=2 shiftwidth=2 ")

-- Highlight on yank
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]])
