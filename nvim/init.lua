--[[
TODO:
- consider switching from lazy to builtin vim.pack
- consider switching from nvim-web-devicons to mini.icons
-- version control lockfile when this issue is resolved: https://github.com/neovim/neovim/issues/36078
--]]

-- SETTINGS

local globals = {
	mapleader = " ",
	maplocalleader = " ",
	netrw_banner = false,
}

local options = {
	mouse = "",
	undofile = true,
	wrap = true,
	linebreak = true,
	spell = false,
	spelllang = "en_gb",
	number = true,
	relativenumber = true,
	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	expandtab = true,
	foldmethod = "expr",
	foldenable = false,
	showmode = false,
	termguicolors = true,
	splitright = true,
	ignorecase = true,
	smartcase = true,
	laststatus = 3,
	spellfile = vim.fs.normalize("~/dotfiles/nvim/spell/en.utf-8.add"),
}

local function set_options(opts, option_group)
	for key, value in pairs(opts) do
		option_group[key] = value
	end
end

set_options(globals, vim.g)
set_options(options, vim.o)

-- PLUGINS
require("mini")
require("fuzzy")
require("colorscheme")
require("explorer")
require("formatting")
require("git")
require("snippets")
require("completion")
require("lsp")
require("debugger")
require("treesitter")
require("statusline")

-- PLUGINS

-- bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- FUNCTIONALITY

	-- markdown previews
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
	},
}, {
	lockfile = "~/dotfiles/nvim/lazy-lock.json",

	performance = {
		reset_packpath = false,
		rtp = { reset = false },
	},
})

-- KEYMAPS

-- resizing windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +5<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -5<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<cr>")

-- easier escape key for macbook with touchbar
vim.keymap.set({ "i", "t", "v", "c", "n" }, "§", "<Esc>", { remap = true })

-- sane escape for terminal and command modes
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("c", "<Esc>", "<C-C><Esc>")

-- toggle relative number
vim.keymap.set("n", "<leader>n", function()
	vim.o.relativenumber = not vim.o.relativenumber
end)

-- quickfix navigation
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>")
vim.keymap.set("n", "<C-k>", "<cmd>cprevious<cr>")

-- easier config reloading
vim.keymap.set("n", "<leader>rr", "<cmd>restart<cr>")

-- FILETYPE DETECTION

vim.filetype.add({
	filename = {
		["justfile"] = "just",
		["Jenkinsfile"] = "groovy",
	},
	pattern = {
		[".*.html"] = function(_, bufnr)
			local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			for _, line in ipairs(content) do
				if line:match("{%%") or line:match("%%}") or line:match("{{") or line:match("}}") then
					return "htmldjango"
				end
			end
		end,
		["Dockerfile.*"] = "dockerfile",
		[".*/templates/.*%.yaml"] = "helm",
		[".*/templates/.*%.tpl"] = "helm",
		[".*%.tf"] = "terraform",
	},
})

-- AUTOCOMMANDS

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "helm", "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	group = vim.api.nvim_create_augroup("JavascriptFiletype", { clear = true }),
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "go",
	group = vim.api.nvim_create_augroup("GoFiletype", { clear = true }),
	callback = function()
		vim.opt_local.tabstop = 8
		vim.opt_local.shiftwidth = 8
	end,
})
