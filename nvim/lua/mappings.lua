
-- helpers
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function remap(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = false, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- tab, buffer and window navigation
nmap('<leader>p', '<CMD>tabn<CR>')
nmap('<leader>o', '<CMD>tabp<CR>')

nmap('<leader>i', '<CMD>bn<CR>')
nmap('<leader>u', '<CMD>bp<CR>')

nmap('<leader>h', '<C-w>h')
nmap('<leader>j', '<C-w>j')
nmap('<leader>k', '<C-w>k')
nmap('<leader>l', '<C-w>l')

-- quit shortcuts
nmap('<leader>q', '<CMD>qa!<CR>')
nmap('<leader>w', '<CMD>wqa!<CR>')

-- comment and uncomment line
nmap('<leader>/', "<CMD>lua require('Comment.api').call('toggle_current_linewise_op')<CR>g@$")
map('n', '<leader>c', '<CMD>lua require("Comment.api").call("toggle_linewise_op")<CR>g@')

-- remove highlights
nmap('<leader>,', '<CMD>nohlsearch<CR>')
-- terminal shortcut
nmap('<leader>t', '<CMD>bo vs term://zsh<CR> :vert res -20<CR>')

-- easier escape key for macbook with touchpad
local esc = "§"
remap('i', esc, '<Esc>')
remap('t', esc, '<Esc>')
remap('v', esc, '<Esc>')
remap('c', esc, '<Esc>')
map('t', '<Esc>', '<C-\\><C-n>')
map('v', '<Esc>', '<Esc>')
map('c', '<Esc>', '<C-C><Esc>')

-- plugin-relevant mappings
nmap('<C-n>', '<CMD>NvimTreeToggle<CR>')
