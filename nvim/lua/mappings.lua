local utils = require("utils")
local map = vim.keymap.set
local esc = "§"

-- source config file
map("n", "<leader>sf", "<cmd>luafile $MYVIMRC<cr>")

-- tab, buffer and window navigation
map("n", "<TAB>", "<cmd>tabn<cr>")
map("n", "<S-TAB>", "<cmd>tabp<cr>")

map("n", "<leader>[", "<cmd>bn<cr>")
map("n", "<leader>]", "<cmd>bp<cr>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<C-Up>", "<cmd>resize +5<cr>")
map("n", "<C-Down>", "<cmd>resize -5<cr>")
map("n", "<C-Right>", "<cmd>vertical resize +5<cr>")
map("n", "<C-Left>", "<cmd>vertical resize -5<cr>")

map("n", "<leader>mk", "<cmd>split<cr>")
map("n", "<leader>ml", "<cmd>vsplit<cr>")
map("n", "<leader>mr", "<C-w>R")

map("n", "<leader>mt", "<cmd>vsplit | vertical resize 50 | term <cr>")

-- quit shortcuts
map("n", "<leader>q", "<cmd>qa<cr>")
map("n", "<leader>w", "<cmd>q<cr>")

-- save shortcut
map("n", "<leader>e", "<cmd>w<cr>")

-- remove highlights
map("n", "<leader>,", "<cmd>nohlsearch<cr>")

-- go back
map("n", "<leader>b", "<C-^>")

-- easier escape key for macbook with touchpad
map({ "i", "t", "v", "c", "n" }, esc, "<Esc>", { remap = true })
map("t", "<Esc>", "<C-\\><C-n>")
map("v", "<Esc>", "<Esc>")
map("c", "<Esc>", "<C-C><Esc>")

-- run current file
map("n", "<leader>rp", utils.run_file)

-- lsp mappings
map("n", "<leader>d", vim.diagnostic.open_float)

-- toggle relative line numbers
map("n", "<leader>n", utils.toggle_relative_line_numbers)

-- toggles backgound between light and dark
map("n", "<leader>sc", utils.toggle_theme_background)

-- Word count shortcut
map({ "n", "v" }, "<leader>c", utils.count_words)

-- Toggle spellcheck
map("n", "<leader>s", "<cmd>set spell!<cr>")

-- plugin-relevant mappings

-- Zen Mode
map("n", "<leader>z", "<cmd>ZenMode<cr>")

-- markdown preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>")

-- git commands
map("n", "<leader>g", "<cmd>Neogit<cr>")
