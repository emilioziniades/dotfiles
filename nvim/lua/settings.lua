vars = require('variables')

-- theme (time dependent)

vim.o.background = vars.background
vim.cmd('colorscheme ' .. vars.theme )

-- other settings
--

vim.g.mapleader = ' '

vim.o.wrap = true
vim.o.linebreak = true
vim.o.spell = false
vim.o.spelllang = "en_uk"
vim.o.number = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.foldmethod = 'syntax'
vim.o.showmode = false
vim.cmd('highlight link goBuiltins Keyword')

