
-- helpers
function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

function nmap(shortcut, command)
  map('n', shortcut, command)
end

function imap(shortcut, command)
  map('i', shortcut, command)
end

-- tab, buffer and window navigation
nmap('<leader>p', ':tabn<CR>')
nmap('<leader>o', ':tabp<CR>')

nmap('<leader>i', ':bn<CR>')
nmap('<leader>u', ':bp<CR>')

nmap('<leader>h', '<C-w>h')
nmap('<leader>j', '<C-w>j')
nmap('<leader>k', '<C-w>k')
nmap('<leader>l', '<C-w>l')

-- quit shortcuts
nmap('<leader>q', ':qa!<CR>')
nmap('<leader>w', ':wqa!<CR>')

-- comment and uncomment line
nmap('<leader>/', ':s:^://<CR> :nohlsearch<CR>')
nmap('<leader>.', ':s:^\\s*//::e<CR> :nohlsearch<CR>')

-- remove highlights
nmap('<leader>,', ':nohlsearch<CR>')
-- terminal shortcut
nmap('<leader>t', ':bo vs term://zsh<CR> :vert res -20<CR>')

-- easier escape keys
local esc = "§"
--local esc = "<Esc>"
imap(esc, '<Esc>')
map('t', esc, '<C-\\><C-n>')
map('v', esc, '<Esc>')
map('c', esc, '<C-C><Esc>')

-- plugin-relevant mappings
nmap('<C-n>', ':NvimTreeToggle<CR>')
