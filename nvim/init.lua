--[[ 
TODO:
- rust
    - debug test via lldb's cargo field (https://github.com/mfussenegger/nvim-dap/discussions/671#discussioncomment-3592258 and 
    https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#cargo-support)
- csharp
    - add ability to debug tests
- nix
    - package codelldb 
]]

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

	--lsp
	{
		"neovim/nvim-lspconfig",
		config = function()
			local on_attach = function(_, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)
			end

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local lspconfig = require("lspconfig")

			local language_servers = {
				pyright = {},
				ruff = {},
				gopls = {},
				ts_ls = {},
				rust_analyzer = {},
				hls = {},
				terraformls = {},
				nil_ls = {},
				bashls = {},
				nushell = {},
				fsautocomplete = {},
				markdown_oxide = {
					capabilities = {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					},
				},
				csharp_ls = {
					handlers = {
						["textDocument/definition"] = require("csharpls_extended").handler,
					},
				},
				lua_ls = {
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end,
					settings = {
						Lua = {
							runtime = {
								version = "LuaJIT",
							},
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								checkThirdParty = false,
								library = {
									vim.env.RUNTIME,
									"${3rd}/luv/library",
								},
							},
							telemetry = {
								enable = false,
							},
						},
					},
				},
			}

			for language_server, language_server_config in pairs(language_servers) do
				local default_config = {
					capabilities = capabilities,
					on_attach = on_attach,
				}
				language_server_config = vim.tbl_deep_extend("force", default_config, language_server_config)
				lspconfig[language_server].setup(language_server_config)
			end
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
		keys = { { "<leader>tt", "<cmd>Trouble diagnostics toggle<cr>" } },
	},
	"Decodetalkers/csharpls-extended-lsp.nvim",
	"onsails/lspkind-nvim",

	-- commenting
	{
		"numToStr/Comment.nvim",
		opts = {},
	},

	-- formatter
	{
		"stevearc/conform.nvim",
		config = function()
			vim.g.conform_format_on_save = true

			local function format_on_save_if_active(format_on_save_opts)
				return function()
					if vim.g.conform_format_on_save then
						return format_on_save_opts
					end
				end
			end

			vim.api.nvim_create_user_command("ConformToggle", function()
				vim.g.conform_format_on_save = not vim.g.conform_format_on_save
			end, { desc = "toggles formatting for the current buffer" })

			require("conform").setup({
				notify_on_error = true,
				format_on_save = format_on_save_if_active({
					timeout_ms = 2000,
					lsp_fallback = true,
				}),
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_format" },
					go = { "gofumpt" },
					rust = { "rustfmt" },
					cs = { "csharpier" },
					fsharp = { "fantomas" },
					nix = { "alejandra" },
					terraform = { "terraform_fmt" },
					hcl = { "terraform_fmt" },
					sh = { "shfmt" },
					haskell = { "fourmolu" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					javascriptreact = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					yaml = { "prettier" },
					htmldjango = { "djlint" },
					toml = { "taplo" },
					just = { "just" },
					scheme = { "scheme_format" },
				},
				formatters = {
					scheme_format = {
						command = "scheme-format",
						args = { "-i", "$FILENAME" },
						stdin = false,
					},
				},
			})
		end,
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "ConformToggle" },
	},

	-- git
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>g", "<cmd>Git<cr>" },
		},
		lazy = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
			},
			on_attach = function(bufnr)
				local gitsigns = require("gitsigns")
				vim.keymap.set("n", "[c", gitsigns.prev_hunk, { buffer = bufnr })
				vim.keymap.set("n", "]c", gitsigns.next_hunk, { buffer = bufnr })
				vim.keymap.set("n", "<leader>cp", gitsigns.preview_hunk, { buffer = bufnr })
				vim.keymap.set("n", "<leader>cs", gitsigns.stage_hunk, { buffer = bufnr })
				vim.keymap.set("n", "<leader>cu", gitsigns.undo_stage_hunk, { buffer = bufnr })
			end,
		},
	},

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

	-- telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {

			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-file-browser.nvim" },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
							["<C-j>"] = require("telescope.actions").move_selection_next,
							["<C-k>"] = require("telescope.actions").move_selection_previous,
							["<C-s>"] = require("telescope.actions.layout").toggle_preview,
						},
					},
					preview = {
						hide_on_startup = true,
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("file_browser")

			local function file_browser_cwd()
				telescope.extensions.file_browser.file_browser({ path = vim.fn.expand("%:p:h") })
			end

			vim.keymap.set("n", "<leader><space>", builtin.buffers)
			vim.keymap.set("n", "<leader>ff", builtin.find_files)
			vim.keymap.set("n", "<leader>fg", builtin.live_grep)
			vim.keymap.set("n", "<leader>fh", builtin.help_tags)
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
			vim.keymap.set("n", "<leader>fb", builtin.current_buffer_fuzzy_find)
			vim.keymap.set("n", "<leader>fc", builtin.colorscheme)
			vim.keymap.set("n", "<leader>fp", telescope.extensions.file_browser.file_browser)
			vim.keymap.set("n", "<leader>fe", file_browser_cwd)
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

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			local t = ls.text_node

			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})

			ls.add_snippets("python", {
				s("bp", t({ "breakpoint()" })),
			})

			vim.keymap.set({ "i", "s" }, "<c-s>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<c-a>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })
		end,
	},

	-- completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = {
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-e>"] = cmp.mapping({
						i = cmp.mapping.abort(),
						c = cmp.mapping.close(),
					}),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
				},
				sources = cmp.config.sources({
					{
						name = "nvim_lsp",
						option = {
							markdown_oxide = {
								keyword_pattern = [[\(\k\| \|\/\|#\)\+]],
							},
						},
					},
					{ name = "luasnip" },
					{ name = "nvim_lua" },
					{ name = "buffer" },
					{ name = "path" },
					{ name = "buffer" },
					-- { name = "name", keyword_length = n, max_item_count = n,  }
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						menu = {
							buffer = "[buf]",
							nvim_lsp = "[LSP]",
							nvim_lua = "[api]",
							path = "[path]",
							luasnip = "[snip]",
						},
					}),
				},
			})
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline", keyword_length = 2 },
				}),
			})
		end,
	},

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			{ "nushell/tree-sitter-nu", build = ":TSUpdate nu" },
		},
		build = ":TSUpdate",
		config = function()
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.scheme = {
				install_info = {
					url = "https://github.com/6cdh/tree-sitter-scheme",
					files = { "src/parser.c" },
					branch = "main",
				},
			}

			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				ensure_installed = {
					"bash",
					"cooklang",
					"c_sharp",
					"css",
					"dockerfile",
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
				},
			})

			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.keymap.set("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
		end,
	},

	{
		"echasnovski/mini.nvim",
		config = function()
			-- bracket add/delete/replace
			require("mini.surround").setup({
				n_lines = 100,
			})
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

	-- show indents
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
			scope = {
				show_start = false,
				show_end = false,
			},
			exclude = {
				filetypes = {
					"help",
					"packer",
				},
				buftypes = {
					"terminal",
					"nofile",
				},
			},
		},
	},

	--brackets
	{
		"windwp/nvim-autopairs",
		opts = {
			disable_filetype = { "TelescopePrompt", "scheme" },
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

	-- rainbow parenthesis
	{
		"HiPhish/rainbow-delimiters.nvim",
		main = "rainbow-delimiters.setup",
		opts = {},
		ft = "scheme",
	},

	-- colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			vim.cmd.colorscheme("catppuccin-mocha")
		end,
		lazy = false,
		priority = 1000,
	},
	{
		"aktersnurra/no-clown-fiesta.nvim",
		opts = {},
	},
	{
		"rebelot/kanagawa.nvim",
		opts = {},
	},
}, { lockfile = "~/dotfiles/nvim/lazy-lock.json" })

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
		vim.highlight.on_yank()
	end,
})
