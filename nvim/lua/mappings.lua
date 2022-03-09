local utils = require("utils")
local map = utils.map
local nmap = utils.nmap
local remap = utils.remap

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
nmap("<leader>q", "<CMD>qa<CR>")

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

-- Go mappings
nmap("<leader>gr", "<CMD>!go run %<CR>")

--Python mappings
nmap("<leader>pr", "<CMD>!python %<CR>")

-- lsp mappings
nmap("<leader>d", "<CMD> lua vim.diagnostic.open_float()<CR>")

-- toggle relative line numbers
nmap("<leader>n", '<CMD>lua require("utils").toggle_relative_line_numbers()<CR>')

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

-- FTerm

nmap("<C-t>", '<CMD>lua require("FTerm").toggle()<CR>')
map("t", "<C-t>", '<Esc><CMD>lua require("FTerm").toggle()<CR>')
nmap("<leader>tq", '<CMD>lua require("FTerm").exit()<CR>')
map("t", "<leader>tq", '<Esc><CMD>lua require("FTerm").exit()<CR>')

-- Telescope

nmap("<leader>ff", "<cmd>Telescope find_files<cr>")
nmap("<leader>fg", "<cmd>Telescope live_grep<cr>")
nmap("<leader>fb", "<cmd>Telescope buffers<cr>")
nmap("<leader>fh", "<cmd>Telescope help_tags<cr>")
