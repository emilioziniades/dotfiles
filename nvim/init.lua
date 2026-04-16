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

	-- debug
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			vim.api.nvim_set_hl(0, "DapGreen", { fg = "#9ece6a" })
			vim.api.nvim_set_hl(0, "DapRed", { fg = "#b21009" })
			vim.api.nvim_set_hl(0, "DapOrange", { fg = "#ff7f00" })
			--
			vim.fn.sign_define("DapBreakpoint", { texthl = "DapGreen", linehl = "", numhl = "DapGreen" })
			vim.fn.sign_define("DapBreakpointRejected", { texthl = "DapRed", linehl = "", numhl = "DapRed" })
			vim.fn.sign_define("DapStopped", { texthl = "DapOrange", linehl = "", numhl = "DapOrange" })

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<leader>dx", dap.terminate)

			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			local function stem(name)
				return vim.fs.basename(name):match("(.*)%.")
			end

			local function find_project_dlls()
				local csproj_files = vim.fs.find(function(name)
					return name:match(".*%.csproj$")
				end, { limit = math.huge, type = "file" })

				local project_names = vim.iter(csproj_files)
					:map(function(csproj_file)
						return stem(csproj_file)
					end)
					:totable()

				local dll_files = vim.fs.find(function(name, path)
					return vim.iter(project_names):any(function(project_name)
						return name:match(project_name .. "%.dll")
							and path:match(project_name)
							and path:match("bin")
							and not path:match("ref")
					end)
				end, { limit = math.huge, type = "file" })

				local dll_file = nil
				vim.ui.select(dll_files, {
					prompt = "Select project to run:",
					format_item = function(item)
						return stem(item) .. " (" .. item .. ")"
					end,
				}, function(choice)
					dll_file = choice
				end)

				return dll_file or dap.ABORT
			end

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = find_project_dlls,
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = "codelldb",
					args = { "--port", "${port}" },
					-- On windows you may have to uncomment this:
					-- detached = false,
				},
			}

			dap.configurations.rust = {
				{
					type = "codelldb",
					name = "launch - codelldb",
					request = "launch",
					program = function()
						return vim.fn.input({ "Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file" })
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			vim.keymap.set("n", "<leader>de", dapui.eval)

			-- open dapui automatically
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			dapui.setup()
		end,
	},
	{
		"leoluz/nvim-dap-go",
		ft = { "go" },
		config = function()
			local dapgo = require("dap-go")
			dapgo.setup()
			vim.keymap.set("n", "<leader>dt", dapgo.debug_test)
		end,
	},

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

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			treesitter.install({
				"bash",
				"cooklang",
				"c_sharp",
				"css",
				"dockerfile",
				"elixir",
				"fennel",
				"fsharp",
				"go",
				"groovy",
				"haskell",
				"hcl",
				"helm",
				"html",
				"htmldjango",
				"javascript",
				"json",
				"just",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"rust",
				"scheme",
				"sql",
				"terraform",
				"toml",
				"tsx",
				"tsx",
				"typescript",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})

			-- enable folding
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

			-- enable highlighting
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "*",
				callback = function(args)
					local bufnr = args.buf
					local filetype = args.match
					local parser = vim.treesitter.language.get_lang(filetype)
					local installed_parsers = treesitter.get_installed()
					if vim.list_contains(installed_parsers, parser) then
						vim.treesitter.start(bufnr)
					end
				end,
			})
		end,
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
