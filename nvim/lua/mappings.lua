local utils = require("utils")
local map = vim.keymap.set
local esc = "§"

-- tab, buffer and window navigation
map("n", "<TAB>", "<cmd>tabn<cr>")
map("n", "<S-TAB>", "<cmd>tabp<cr>")

map("n", "<leader>[", "<cmd>bn<cr>")
map("n", "<leader>]", "<cmd>bp<cr>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<leader>ms", "<cmd>split<cr>")
map("n", "<leader>mv", "<cmd>vsplit<cr>")
map("n", "<leader>mr", "<C-w>R")

map("n", "<leader>ml", "<C-w>L")
map("n", "<leader>mk", "<C-w>K")
map("n", "<leader>mj", "<C-w>J")
map("n", "<leader>mh", "<C-w>H")

map("n", "<C-Up>", "<cmd>resize +5<cr>")
map("n", "<C-Down>", "<cmd>resize -5<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +5<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -5<cr>")

map("n", "<leader>mt", "<cmd>vsplit | vertical resize 50 | term <cr>")

-- quit
map("n", "<leader>q", "<cmd>qa<cr>")
map("n", "<leader>w", "<cmd>q<cr>")

-- save
map("n", "<leader>e", "<cmd>w<cr>")

-- remove highlights
map("n", "<leader>,", "<cmd>nohlsearch<cr>")

-- go back
map("n", "<leader>b", "<C-^>")

-- easier escape key for macbook
map({ "i", "t", "v", "c", "n" }, esc, "<Esc>", { remap = true })
map("t", "<Esc>", "<C-\\><C-n>")
map("v", "<Esc>", "<Esc>")
map("c", "<Esc>", "<C-C><Esc>")

map("n", "<leader>n", utils.toggle_relative_line_numbers)
