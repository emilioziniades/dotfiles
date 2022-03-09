local utils = {}

utils.map = function(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

utils.remap = function(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = false, silent = true })
end

utils.nmap = function(shortcut, command)
	utils.map("n", shortcut, command)
end

utils.toggle_relative_line_numbers = function()
	if vim.o.relativenumber then
		vim.o.relativenumber = false
	else
		vim.o.relativenumber = true
	end
end

return utils
