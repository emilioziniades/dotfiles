vars = require('variables')

--vim plug

-- auto install vim plug if not already installed
config_dir = vim.fn.stdpath('config')
if vim.fn.empty(vim.fn.glob(config_dir .. '/autoload/plug.vim')) == 1
	then
		os.execute('curl -fLo ' .. config_dir .. '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1' )
		vim.cmd('autocmd VimEnter * PlugInstall --sync ')
end

--
local Plug = vim.fn['plug#']

vim.call('plug#begin', config_dir .. '/plugged')

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
