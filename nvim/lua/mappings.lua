local utils = require("utils")
local map = vim.keymap.set
local esc = "§"

-- source config file
map("n", "<leader><leader>s", "<cmd>luafile $MYVIMRC<cr>")

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

-- quit shortcuts
map("n", "<leader>q", "<cmd>qa<cr>")

-- save shortcut
map("n", "<leader>w", "<cmd>w<cr>")

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

-- insert current file into repl
map("n", "<leader>rr", utils.start_repl)

-- lsp mappings
map("n", "<leader>d", vim.diagnostic.open_float)

-- toggle relative line numbers
map("n", "<leader>n", utils.toggle_relative_line_numbers)

-- toggles backgound between light and dark
map("n", "<leader><leader>c", utils.toggle_theme_background)

-- Word count shortcut
map({ "n", "v" }, "<leader>c", utils.count_words)

-- plugin-relevant mappings

-- packer
map("n", "<leader>ps", "<cmd>PackerSync<cr>")
map("n", "<leader>pc", "<cmd>PackerCompile<cr>")

-- NvimTree
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>")

-- Zen Mode
map("n", "<leader>z", "<cmd>ZenMode<cr>")

-- markdown preview
map("n", "<leader>m", "<cmd>MarkdownPreviewToggle<cr>")

-- Toggle spellcheck
map("n", "<leader>s", "<cmd>set spell!<cr>")

-- nvim-treesitter
map("n", "<leader><leader>r", "<cmd>write | edit | TSBufEnable highlight<cr>")

-- git commands
map("n", "<leader>gg", "<cmd>Neogit<cr>")

-- FTerm

map({ "n", "t" }, "<leader>tt", require("FTerm").toggle)
map({ "n", "t" }, "<leader>tq", require("FTerm").exit)

-- Telescope

map("n", "<leader><space>", require("telescope.builtin").buffers)
map("n", "<leader>ff", require("telescope.builtin").find_files)
map("n", "<leader>fg", require("telescope.builtin").live_grep)
map("n", "<leader>fh", require("telescope.builtin").help_tags)
map("n", "<leader>fo", require("telescope.builtin").oldfiles)
map("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find)
map("n", "<leader>fc", require("telescope.builtin").colorscheme)
