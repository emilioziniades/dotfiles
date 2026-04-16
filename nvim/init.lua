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

	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
		opts = {
			options = {
				icons_enabled = false,
				theme = "auto",
				component_separators = "|",
				section_separators = "",
				globalstatus = true,
			},
			sections = {
				lualine_c = { { "filename", path = 1 } },
			},
			inactive_sections = {
				lualine_c = { { "filename", path = 1 } },
			},
		},
	},

	{
		"nvim-mini/mini.nvim",
		config = function()
			-- bracket add/delete/replace
			require("mini.surround").setup({
				n_lines = 100,
			})

			--automatic brackets
			require("mini.pairs").setup()

			-- commenting
			require("mini.comment").setup()
		end,
	},

	{
		"Olical/conjure",
		ft = { "scheme", "fennel" },
		lazy = true,
		init = function()
			vim.g["conjure#filetype#scheme"] = "conjure.client.guile.socket"
			vim.g["conjure#client#guile#socket#pipename"] = "guile-repl.socket"
			vim.g["conjure#debug"] = false
			vim.g["conjure#mapping#doc_word"] = false
		end,
		dependencies = {
			"PaterJason/cmp-conjure",
			lazy = true,
			config = function()
				local cmp = require("cmp")
				local config = cmp.get_config()
				table.insert(config.sources, { name = "conjure" })
				return cmp.setup(config)
			end,
		},
	},

	--icons
	"nvim-tree/nvim-web-devicons",

	-- zen mode
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 1,
				width = 0.80,
				height = 0.90,
				options = {
					number = false,
					relativenumber = false,
					laststatus = 0,
				},
			},
			plugins = {
				twilight = { enabled = false },
				gitsigns = { enabled = true },
				tmux = { enabled = true },
			},
			on_close = function()
				vim.o.laststatus = 3
			end,
		},
		keys = {
			{
				"<leader>z",
				function()
					require("zen-mode").toggle()
				end,
			},
		},
	},

	-- todo highlights
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

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
