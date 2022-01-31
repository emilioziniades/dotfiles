vars = require('variables')

vim.g.mapleader = ' '

vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true

vim.o.foldmethod= 'syntax'

-- theme (time dependent)

vim.o.background = vars.background
vim.cmd('colorscheme ' .. vars.theme )


