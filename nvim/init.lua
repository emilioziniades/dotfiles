--[[ 
TODO:
- package management
    - consider switching to lazy.nvim
- lsp
    - mason ensure installed for dap clients and formatters
    - tidy up lsp config based on kickstart.nvim
    - look at trouble.nvim
- dotnet
    - build project before every debug
    - identify .dll's and provide selection option
- rust
    - debug test via lldb's cargo field (https://github.com/mfussenegger/nvim-dap/discussions/671#discussioncomment-3592258 and https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#cargo-support)
]]
-- UTILITY FUNCTIONS

function Map(mode, lhs, rhs, more_opts)
	local opts = { noremap = true, silent = true }
	more_opts = more_opts or {}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", opts, more_opts))
end

function Mason_path(executable)
	return vim.fn.stdpath("data") .. "/mason/bin/" .. executable
end

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

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	use({
		"wbthomason/packer.nvim",
		config = function()
			Map("n", "<leader>ps", "<cmd>PackerSync<cr>")
			Map("n", "<leader>pc", "<cmd>PackerCompile<cr>")
		end,
	})

	-- FUNCTIONALITY

	--lsp
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("onsails/lspkind-nvim")
	use({
		"jose-elias-alvarez/null-ls.nvim",
		requires = { "nvim-lua/plenary.nvim" },
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
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			local language_servers = { "pyright", "gopls", "tsserver", "rust_analyzer", "lua_ls", "csharp_ls" }

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = language_servers,
			})

			Map("n", "<space>d", vim.diagnostic.open_float)
			Map("n", "[d", vim.diagnostic.goto_prev)
			Map("n", "]d", vim.diagnostic.goto_next)

			local on_attach = function(client, bufnr)
				-- null-ls handles formatting
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingProvider = false

				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				Map("n", "gD", vim.lsp.buf.declaration, bufopts)
				Map("n", "gd", vim.lsp.buf.definition, bufopts)
				Map("n", "gi", vim.lsp.buf.implementation, bufopts)
				Map("n", "gh", vim.lsp.buf.signature_help, bufopts)
				-- Map("n", "gr", vim.lsp.buf.references, bufopts) - use telescope instead
				Map("n", "K", vim.lsp.buf.hover, bufopts)
				Map("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				Map("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				Map("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				Map("n", "<space>f", vim.lsp.buf.format, bufopts)
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
	})

	-- git
	use({
		"tpope/vim-fugitive",
		config = function()
			Map("n", "<leader>g", "<cmd>Git<cr>")
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
				},
			})
		end,
	})

	-- debug
	use({
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			vim.fn.sign_define("DapBreakpoint", { text = "🟢", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "⚠️", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "", linehl = "", numhl = "" })

			Map("n", "<leader>b", dap.toggle_breakpoint)
			Map("n", "<F5>", dap.continue)
			Map("n", "<F10>", dap.step_over)
			Map("n", "<F11>", dap.step_into)
			Map("n", "<F12>", dap.step_out)
			Map("n", "<leader>dx", dap.terminate)

			dap.adapters.coreclr = {
				type = "executable",
				command = Mason_path("netcoredbg"),
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = Mason_path("codelldb"),
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
	})
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			local dap, dapui = require("dap"), require("dapui")

			Map("n", "<leader>de", dapui.eval)

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
	})
	use({
		"leoluz/nvim-dap-go",
		ft = { "go" },
		config = function()
			local dapgo = require("dap-go")
			dapgo.setup()
			Map("n", "<leader>dt", dapgo.debug_test)
		end,
	})

	-- telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local builtin = require("telescope.builtin")
			local themes = require("telescope.themes")

			local ivy = themes.get_ivy({
				preview = {
					hide_on_startup = true,
				},
				layout_config = {
					height = 0.25,
				},
			})

			local dropdown = themes.get_dropdown({
				layout_config = {
					height = 0.4,
					width = 0.6,
				},
			})

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
					layout_strategy = "horizontal",
					layout_config = {
						horizontal = {
							height = function(_, _, max_lines)
								local max_height = 60
								local lines_padding = 4
								return math.min(max_lines - lines_padding, max_height)
							end,
							width = function(_, max_columns, _)
								local max_width = 180
								local columns_padding = 12
								return math.min(max_columns - columns_padding, max_width)
							end,
							preview_width = 0.65,
						},
					},
				},
				pickers = {
					buffers = ivy,
					lsp_references = ivy,
					current_buffer_fuzzy_find = dropdown,
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

			Map("n", "<leader><space>", builtin.buffers)
			Map("n", "<leader>ff", builtin.find_files)
			Map("n", "<leader>fg", builtin.live_grep)
			Map("n", "<leader>fh", builtin.help_tags)
			Map("n", "<leader>fo", builtin.oldfiles)
			Map("n", "<leader>fb", builtin.current_buffer_fuzzy_find)
			Map("n", "<leader>fc", builtin.colorscheme)
			Map("n", "<leader>fp", telescope.extensions.file_browser.file_browser)
			Map("n", "<leader>fe", file_browser_cwd)
			Map("n", "<leader>fd", find_dotfiles)
			Map("n", "gr", builtin.lsp_references)
		end,
	})

	-- status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = "|",
					section_separators = "",
					globalstatus = true,
				},
			})
		end,
	})

	-- snippets
	use({
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

			Map({ "i", "s" }, "<c-s>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			Map({ "i", "s" }, "<c-a>", function()
				if ls.jumpable(-1) then
					ls.jump(-1)
				end
			end, { silent = true })
		end,
	})

	-- completion
	use({
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
	})
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")

	-- treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
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
				},
			})

			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			Map("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})

	-- commenting
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- show indents
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				space_char_blankline = " ",
				show_current_context = true,
				show_current_context_start = false,
			})
			vim.g.indent_blankline_char = "┊"
			vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
			vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
			vim.g.indent_blankline_show_trailing_blankline_indent = false
		end,
	})

	--brackets
	use({
		"windwp/nvim-autopairs",
		config = function()
			local Rule = require("nvim-autopairs.rule")
			local npairs = require("nvim-autopairs")
			npairs.setup()

			npairs.add_rule(Rule("<", ">", "javascript"))
		end,
	})
	use("tpope/vim-surround")

	--icons
	use({
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	})

	-- twilight + zen mode
	use({
		"folke/twilight.nvim",
		config = function()
			require("twilight").setup()
		end,
	})
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
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
			})
			Map("n", "<leader>z", require("zen-mode").toggle)
		end,
	})

	use({
		"folke/tokyonight.nvim",
		config = function()
			require("tokyonight").setup({
				styles = {
					floats = "normal",
				},
			})
			vim.cmd.colorscheme("tokyonight-night")
		end,
	})

	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- KEYMAPS

-- buffer and window navigation
Map("n", "<leader>[", "<cmd>bn<cr>")
Map("n", "<leader>]", "<cmd>bp<cr>")

Map("n", "<C-Up>", "<cmd>resize +5<cr>")
Map("n", "<C-Down>", "<cmd>resize -5<cr>")
Map("n", "<C-Right>", "<cmd>vertical resize +5<cr>")
Map("n", "<C-Left>", "<cmd>vertical resize -5<cr>")

Map("n", "<leader>mt", "<cmd>vsplit | vertical resize 50 | term <cr>")
Map("n", "<leader>ms", "<cmd>tabnew | term <cr>")

Map("n", "<leader>q", "<cmd>q<cr>")

Map("n", "<leader>w", "<cmd>w<cr>")

-- easier escape key for macbook with touchbar
Map({ "i", "t", "v", "c", "n" }, "§", "<Esc>", { remap = true })

-- sane escape for terminal and command modes
Map("t", "<Esc>", "<C-\\><C-n>")
Map("c", "<Esc>", "<C-C><Esc>")

-- toggle relative number
Map("n", "<leader>n", function()
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

Map("n", "<leader>rr", run_file)

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

Map("n", "<leader>rt", test_file)

-- AUTOCOMMANDS

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "init.lua",
	group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd("source % | PackerCompile")
		end)
	end,
})

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
