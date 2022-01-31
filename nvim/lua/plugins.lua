vars = require('variables')

--vim plug

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- themes
Plug('tanvirtin/monokai.nvim')
Plug('NLKNguyen/papercolor-theme')

-- functionality
Plug('fatih/vim-go', { ['do'] = ':GoUpdateBinaries' })
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('nvim-lualine/lualine.nvim')

vim.call('plug#end')

-- vim-go settings
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_function_parameters = 0 
vim.g.go_highlight_types = 0
vim.g.go_fold_enable = {'block', 'import', 'varconst', 'package_comment', 'comment'}

-- nvim-tree configuration 
require'nvim-tree'.setup()

--lualine configuration
require('lualine').setup{
    options = { theme = vars.lualinetheme }
}
