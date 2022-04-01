local utils = require("utils")
local map = utils.map
local nmap = utils.nmap
local remap = utils.remap

-- source config file
nmap("<leader><leader>s", "<cmd>luafile $MYVIMRC<cr>")

-- tab, buffer and window navigation
nmap("<TAB>", "<cmd>tabn<cr>")
nmap("<S-TAB>", "<cmd>tabp<cr>")

nmap("<leader>[", "<cmd>bn<cr>")
nmap("<leader>]", "<cmd>bp<cr>")

nmap("<C-h>", "<C-w>h")
nmap("<C-j>", "<C-w>j")
nmap("<C-k>", "<C-w>k")
nmap("<C-l>", "<C-w>l")

nmap("+", "<cmd>resize +5<cr>")
nmap("-", "<cmd>resize -5<cr>")
nmap(">", "<cmd>vertical resize +5<cr>")
nmap("<", "<cmd>vertical resize -5<cr>")

-- quit shortcuts
nmap("<leader>q", "<cmd>qa<cr>")

-- save shortcut
nmap("<leader>w", "<cmd>w<cr>")

-- remove highlights
nmap("<leader>,", "<cmd>nohlsearch<cr>")

-- go back
nmap("<leader>b", "<C-^>")

-- easier escape key for macbook with touchpad
local esc = "§"
remap("i", esc, "<Esc>")
remap("t", esc, "<Esc>")
remap("v", esc, "<Esc>")
remap("c", esc, "<Esc>")
remap("n", esc, "<Esc>")
map("t", "<Esc>", "<C-\\><C-n>")
map("v", "<Esc>", "<Esc>")
map("c", "<Esc>", "<C-C><Esc>")

-- Mappings to run current file
nmap("<leader>rg", "<cmd>!go run %<cr>")
nmap("<leader>rp", "<cmd>!python %<cr>")
-- lsp mappings
nmap("<leader>d", "<cmd> lua vim.diagnostic.open_float()<cr>")

-- toggle relative line numbers
nmap("<leader>n", [[<cmd>lua require('utils').toggle_relative_line_numbers()<cr>]])

-- plugin-relevant mappings

-- packer
nmap("<leader>ps", "<cmd>PackerSync<cr>")
nmap("<leader>pc", "<cmd>PackerCompile<cr>")

-- NvimTree
nmap("<C-n>", "<cmd>NvimTreeToggle<cr>")

-- Zen Mode
nmap("<leader>z", "<cmd>ZenMode<cr>")

-- Word count shortcut
nmap("<leader>c", "<cmd>w<cr><cmd>!wc -w %<cr>")

-- Toggle spellcheck
nmap("<leader>s", "<cmd>set spell!<cr>")

-- nvim-treesitter
nmap("<leader>r", "<cmd>write | edit | TSBufEnable highlight<cr>")

-- git commands
nmap("<leader>gg", "<cmd>Neogit<cr>")
nmap("<leader>gs", "<cmd>Git<cr>")
nmap("<leader>gd", "<cmd>Gvdiffsplit<cr>")
nmap("<leader>gD", "<cmd>Git diff<cr>")
nmap("<leader>gp", "<cmd>Git push -u origin main<cr>")
-- nmap("<leader>gl", "<cmd>Git log --oneline --all<cr>")
nmap("<leader>gl", "<cmd>Git log --graph --decorate --oneline --all<cr>")
nmap("<leader>gc", "<cmd>Git commit<cr>")
nmap("<leader>ga", "<cmd>Git add .<cr>")

-- FTerm

nmap("<leader>tt", [[<cmd>lua require('FTerm').toggle()<cr>]])
map("t", "<leader>tt", [[<Esc><cmd>lua require('FTerm').toggle()<cr>]])
nmap("<leader>tq", [[<cmd>lua require('FTerm').exit()<cr>]])
map("t", "<leader>tq", [[<Esc><cmd>lua require('FTerm').exit()<cr>]])

-- Telescope

nmap("<leader><space>", [[<cmd>lua require('telescope.builtin').buffers()<cr>]])
nmap("<leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
nmap("<leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
nmap("<leader>fh", [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
nmap("<leader>fo", [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]])
nmap("<leader>fb", [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]])
nmap("<leader>fc", [[<cmd>lua require('telescope.builtin').colorscheme()<cr>]])
