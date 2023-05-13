--[[ 
TODO:
- lsp
    - mason ensure installed for dap clients and formatters - custom function
    - tidy up lsp config based on kickstart.nvim - maybe split into dap.lua and lsp.lua files?
- rust
    - debug test via lldb's cargo field (https://github.com/mfussenegger/nvim-dap/discussions/671#discussioncomment-3592258 and 
    https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#cargo-support)
]]

-- SETTINGS

local globals = {
	mapleader = " ",
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
}

local function set_options(opts, option_group)
	for key, value in pairs(opts) do
		option_group[key] = value
	end
end

set_options(globals, vim.g)
set_options(options, vim.o)

-- PLUGINS

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"onsails/lspkind-nvim",
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local null_ls = require("null-ls")
			local sources = {
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.rustfmt,
				null_ls.builtins.formatting.csharpier,
			}
			null_ls.setup({
				sources = sources,
				on_attach = function(client)
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                augroup END ]])
					end
				end,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local language_servers = { "pyright", "gopls", "tsserver", "rust_analyzer", "lua_ls", "csharp_ls" }

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = language_servers,
			})

			vim.keymap.set("n", "<space>d", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)

			local on_attach = function(client, bufnr)
				-- null-ls handles formatting
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingProvider = false

				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			lspconfig.pyright.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.tsserver.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.rust_analyzer.setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})

			lspconfig.csharp_ls.setup({
				root_dir = function(startpath)
					return lspconfig.util.root_pattern("*.sln")(startpath)
						or lspconfig.util.root_pattern("*.csproj")(startpath)
						or lspconfig.util.root_pattern("*.fsproj")(startpath)
						or lspconfig.util.root_pattern(".git")(startpath)
				end,
				on_attach = on_attach,
				capabilities = capabilities,
			})

			local runtime_path = vim.split(package.path, ";")
			table.insert(runtime_path, "lua/?.lua")
			table.insert(runtime_path, "lua/?/init.lua")

			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end,
	},
	{
		"folke/trouble.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {},
		keys = { { "<leader>tt", "<cmd>TroubleToggle<cr>" } },
	},

	-- git
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>g", "<cmd>Git<cr>" },
		},
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },

	-- debug
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")

			vim.api.nvim_set_hl(0, "DapGreen", { fg = "#9ece6a" })
			vim.api.nvim_set_hl(0, "DapWarningRed", { fg = "#b21009" })
			vim.api.nvim_set_hl(0, "DapAttentionOrange", { fg = "#ff7f00" })

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapGreen", linehl = "", numhl = "DapGreen" })
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "○",
				texthl = "DapWarningRed",
				linehl = "",
				numhl = "DapWarningRed",
			})
			vim.fn.sign_define(
				"DapStopped",
				{ text = "➡️", texthl = "DapAttentionOrange", linehl = "", numhl = "DapAttentionOrange" }
			)

			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
			vim.keymap.set("n", "<F5>", dap.continue)
			vim.keymap.set("n", "<F10>", dap.step_over)
			vim.keymap.set("n", "<F11>", dap.step_into)
			vim.keymap.set("n", "<F12>", dap.step_out)
			vim.keymap.set("n", "<leader>dx", dap.terminate)

			local function mason_path(executable)
				return vim.fn.stdpath("data") .. "/mason/bin/" .. executable
			end

			dap.adapters.coreclr = {
				type = "executable",
				command = mason_path("netcoredbg"),
				args = { "--interpreter=vscode" },
			}

			local function find_project_dlls() end

			vim.api.nvim_create_user_command("Test", find_project_dlls, {})

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						local csproj_files = vim.fs.find(function(name)
							return name:match(".*%.csproj")
						end, { path = vim.fn.getcwd() })

						local project_names = {}
						for _, csproj_file in ipairs(csproj_files) do
							local file_name = vim.fs.basename(csproj_file)
							local project_name = file_name:match("(.*)%.")
							table.insert(project_names, project_name)
						end

						local dll_files = vim.fs.find(function(name)
							for _, project_name in ipairs(project_names) do
								if name:find(".*" .. project_name .. "%.dll") then
									return name
								end
							end
						end, { path = vim.fn.getcwd() })

						-- TODO: it almost works, but it should search from
						-- the project root, not the current file's directory
						-- (maybe that info can come from lsp somehow?)

						local dll_file = ""
						vim.ui.select(dll_files, {
							prompt = "Select project to run:",
						}, function(choice)
							dll_file = choice
						end)
						return dll_file
					end,
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = mason_path("codelldb"),
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
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
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
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
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

			local function find_dotfiles()
				local config_dir = vim.fn.stdpath("config")
				builtin.find_files({ cwd = config_dir })
			end

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
			-- vim.keymap.set("n", "<leader>fp", telescope.extensions.file_browser.file_browser)
			vim.keymap.set("n", "<leader>fe", file_browser_cwd)
			vim.keymap.set("n", "<leader>fd", find_dotfiles)
			vim.keymap.set("n", "gr", builtin.lsp_references)
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
		},
	},

	-- snippets
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local ls = require("luasnip")
			local s = ls.snippet
			-- local sn = ls.snippet_node
			-- local isn = ls.indent_snippet_node
			local t = ls.text_node
			local i = ls.insert_node
			local f = ls.function_node
			-- local c = ls.choice_node
			-- local d = ls.dynamic_node
			-- local r = ls.restore_node
			-- local events = require("luasnip.util.events")
			-- local ai = require("luasnip.nodes.absolute_indexer")
			-- local rep = require("luasnip.extras").rep

			ls.config.set_config({
				history = true,
				updateevents = "TextChanged,TextChangedI",
			})

			ls.add_snippets("python", {
				-- __name__ __main__
				s("nm", {
					t({ [[if __name__ == "__main__":]], "   main()" }),
				}),
				-- iPython debug
				s("db", {
					t({ "from IPython import embed; embed(colors='neutral')  # fmt: skip" }),
				}),
				-- normal debug breakpoint
				s("bp", {
					t({ "breakpoint()" }),
				}),
				-- function definition
				s("df", {
					t("def "),
					i(1),
					t("("),
					i(2),
					t(") -> "),
					i(3),
					t({ ":", "\t" }),
				}),
			})

			ls.add_snippets("go", {
				s("enil", {
					t({ "if err != nil {", "\t" }),
					i(0),
					t({ "", "}" }),
				}),
			})

			ls.add_snippets("javascript", {
				-- html expansion of the form ".tag.class1.class2" or ".tag." for elements without classes
				s({ trig = ".(%a+).([-./a-zA-Z0-9]*)", regTrig = true }, {
					f(function(_, snip)
						local tag = snip.captures[1]
						local class = snip.captures[2]:gsub("[.]", " ")
						if class == "" then
							return string.format([[<%s>]], tag)
						else
							return string.format([[<%s className="%s">]], tag, class)
						end
					end),
					i(0),
					f(function(_, snip)
						local tag = snip.captures[1]
						return string.format([[</%s>]], tag)
					end),
				}),
			})

			local js_like_filetypes = { "javascriptreact", "typescript", "typescriptreact" }
			for _, filetype in ipairs(js_like_filetypes) do
				ls.filetype_extend(filetype, { "javascript" })
			end

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
					["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
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
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline", keyword_length = 3 },
				}),
			})
		end,
	},
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-cmdline",
	"saadparwaiz1/cmp_luasnip",

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				ensure_installed = {
					"go",
					"python",
					"javascript",
					"typescript",
					"tsx",
					"lua",
					"c_sharp",
					"css",
					"rust",
					"html",
					"toml",
					"typescript",
					"tsx",
					"vim",
					"vimdoc",
					"bash",
					"dockerfile",
					"json",
				},
			})

			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.keymap.set("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
		end,
	},

	-- commenting
	{ "numToStr/Comment.nvim", opts = {} },

	-- show indents
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			char = "┊",
			space_char_blankline = " ",
			show_current_context = true,
			show_current_context_start = false,
			show_trailing_blankline_indent = false,
			filetype_exclude = { "help", "packer" },
			buftype_exclude = { "terminal", "nofile" },
		},
	},

	--brackets
	{
		"windwp/nvim-autopairs",
		opts = {},
	},
	"tpope/vim-surround",

	--icons
	"nvim-tree/nvim-web-devicons",

	-- twilight + zen mode
	"folke/twilight.nvim",
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
				},
			},
			plugins = {
				gitsigns = { enabled = true },
			},
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

	-- colorscheme
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd.colorscheme("tokyonight-night")
		end,
		lazy = false,
		priority = 1000,
	},
})

-- KEYMAPS

-- buffer and window navigation
vim.keymap.set("n", "<leader>[", "<cmd>bn<cr>")
vim.keymap.set("n", "<leader>]", "<cmd>bp<cr>")

vim.keymap.set("n", "<C-Up>", "<cmd>resize +5<cr>")
vim.keymap.set("n", "<C-Down>", "<cmd>resize -5<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +5<cr>")
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -5<cr>")

vim.keymap.set("n", "<leader>mt", "<cmd>vsplit | vertical resize 50 | term <cr>")
vim.keymap.set("n", "<leader>ms", "<cmd>tabnew | term <cr>")

-- easier escape key for macbook with touchbar
vim.keymap.set({ "i", "t", "v", "c", "n" }, "§", "<Esc>", { remap = true })

-- sane escape for terminal and command modes
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")
vim.keymap.set("c", "<Esc>", "<C-C><Esc>")

-- toggle relative number
vim.keymap.set("n", "<leader>n", function()
	vim.o.relativenumber = not vim.o.relativenumber
end)

local function run_file()
	local ft = vim.bo.filetype
	local run_cmds = {
		["python"] = [[! echo \\n &&  python %]],
		["go"] = "!go run %",
		["javascript"] = [[! echo \\n && node %]],
		["rust"] = "!cargo run",
	}
	vim.cmd(run_cmds[ft])
end

vim.keymap.set("n", "<leader>rr", run_file)

local function test_file()
	local filename = vim.fn.expand("%:t")
	filename = string.gsub(filename, ".rs", "")
	print(filename)
	local ft = vim.bo.filetype
	local run_cmds = {
		["rust"] = "!cargo test " .. filename,
	}
	vim.cmd(run_cmds[ft])
end

vim.keymap.set("n", "<leader>rt", test_file)

-- AUTOCOMMANDS

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

local function set_filetype_options(group_name, pattern, options_map)
	vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
		pattern = pattern,
		group = vim.api.nvim_create_augroup(group_name, { clear = true }),
		callback = function()
			vim.schedule(function()
				for option_key, option_value in pairs(options_map) do
					vim.api.nvim_set_option_value(option_key, option_value, { scope = "local" })
				end
			end)
		end,
	})
end

set_filetype_options(
	"JavaScriptFile",
	{ "*.js", "*.jsx", "*.html", "*.ts", "*.tsx", "*.tpl" },
	{ tabstop = 2, shiftwidth = 2 }
)

set_filetype_options("GolangFile", { "*.go" }, { tabstop = 8 })

set_filetype_options("MdxFile", { "*.mdx" }, { filetype = "markdown" })
