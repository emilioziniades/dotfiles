-- helpers
local function map(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = true, silent = true })
end

local function remap(mode, shortcut, command)
	vim.api.nvim_set_keymap(mode, shortcut, command, { noremap = false, silent = true })
end

local function nmap(shortcut, command)
	map("n", shortcut, command)
end

-- tab, buffer and window navigation
nmap("<TAB>", "<CMD>tabn<CR>")
nmap("<S-TAB>", "<CMD>tabp<CR>")

nmap("<leader>[", "<CMD>bn<CR>")
nmap("<leader>]", "<CMD>bp<CR>")

nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

-- quit shortcuts
nmap("<leader>q", "<CMD>qa!<CR>")
nmap("<leader>w", "<CMD>wa!<CR><CMD>qa!<CR>")

-- comment and uncomment line
nmap("<leader>/", "<CMD>lua require('Comment.api').call('toggle_current_linewise_op')<CR>g@$")
map("n", "<leader>c", '<CMD>lua require("Comment.api").call("toggle_linewise_op")<CR>g@')

-- remove highlights
nmap("<leader>,", "<CMD>nohlsearch<CR>")

-- easier escape key for macbook with touchpad
local esc = "§"
remap("i", esc, "<Esc>")
remap("t", esc, "<Esc>")
remap("v", esc, "<Esc>")
remap("c", esc, "<Esc>")
map("t", "<Esc>", "<C-\\><C-n>")
map("v", "<Esc>", "<Esc>")
map("c", "<Esc>", "<C-C><Esc>")

-- lsp mappings
nmap("<leader>d", "<CMD> lua vim.diagnostic.open_float()<CR>")

-- plugin-relevant mappings

-- NvimTree
nmap("<C-n>", "<CMD>NvimTreeToggle<CR>")

-- Goyo editing (Zen mode)
nmap("<leader>g", "<CMD>Goyo<CR>")

-- Word count shortcut
nmap("<leader>c", "<CMD>w<CR><CMD>!wc -w %<CR>")

-- Toggle spellcheck
nmap("<leader>s", "<CMD>set spell!<CR>")

-- nvim-treesitter
nmap("<leader>r", "<CMD>write | edit | TSBufEnable highlight<CR>")

--lsp-saga

nmap("<leader>f", "<CMD>Lspsaga lsp_finder<CR>")

-- FTerm

nmap("<leader>t", '<CMD>lua require("FTerm").toggle()<CR>')
map("t", "<leader>t", '<Esc><CMD>lua require("FTerm").toggle()<CR>')
