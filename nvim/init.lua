-- UTILITY FUNCTIONS

local utils = {}

utils.I = function(item)
	print(vim.inspect(item))
end

function utils.toggle_relative_line_numbers()
	if vim.o.relativenumber then
		vim.o.relativenumber = false
	else
		vim.o.relativenumber = true
	end
end

function utils.line_number_emphasize()
	local line_num_colour
	if vim.o.background == "light" then
		line_num_colour = "Black"
	else
		line_num_colour = "White"
	end
	vim.o.cursorline = true
	vim.cmd("hi Cursorline guibg=none")
	vim.cmd("hi CursorLineNr term=bold ctermfg=" .. line_num_colour .. " gui=bold guifg=" .. line_num_colour)
end

function utils.toggle_theme_background()
	local colorscheme = vim.cmd("silent colorscheme")
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
	vim.cmd("silent colorscheme " .. colorscheme)
	-- M.line_number_emphasize()
end

function utils.count_words()
	if vim.fn.wordcount().visual_words == 1 then
		print(vim.fn.wordcount().visual_words .. " word selected")
	elseif not (vim.fn.wordcount().visual_words == nil) then
		print(vim.fn.wordcount().visual_words .. " words selected")
	else
		print(vim.fn.wordcount().words .. " words")
	end
end

function utils.run_file()
	local ft = vim.bo.filetype
	local run_cmds = {
		["python"] = [[! echo \\n &&  python %]],
		["go"] = "!go run %",
		["javascript"] = [[! echo \\n && node %]],
		["rust"] = "!cargo run",
	}
	vim.cmd(run_cmds[ft])
end

function utils.test_file()
	local filename = vim.fn.expand("%:t")
	filename = string.gsub(filename, ".rs", "")
	print(filename)
	local ft = vim.bo.filetype
	local run_cmds = {
		["rust"] = "!cargo test " .. filename,
	}
	vim.cmd(run_cmds[ft])
end

function utils.set_variables(vars, var_type)
	for key, value in pairs(vars) do
		var_type[key] = value
	end
end

function utils.map(mode, lhs, rhs, more_opts)
	print("I ran once")
	local opts = { noremap = true, silent = true }
	more_opts = more_opts or {}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", opts, more_opts))
end

function map(mode, lhs, rhs, more_opts)
	print("I ran once")
	local opts = { noremap = true, silent = true }
	more_opts = more_opts or {}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", opts, more_opts))
end

-- PLUGINS

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
	Packer_bootstrap =
		vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
	vim.cmd("packadd packer.nvim")
end

require("packer").startup(function(use)
	use({
		"wbthomason/packer.nvim",
		config = function()
			vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
			vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
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
				-- null_ls.builtins.diagnostics.mypy,
				null_ls.builtins.formatting.goimports,
				null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.rustfmt,
			}
			null_ls.setup({
				sources = sources,
				on_attach = function(client)
					if client.server_capabilities.documentFormattingProvider then
						vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
                augroup END
                ]])
					end
				end,
			})
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		config = function()
			local language_servers = { "pyright", "gopls", "tsserver", "rust_analyzer", "sumneko_lua" }
			local language_servers = { "pyright", "gopls", "tsserver", "rust_analyzer" }

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = language_servers,
			})

			map("n", "<space>d", vim.diagnostic.open_float)
			map("n", "[d", vim.diagnostic.goto_prev)
			map("n", "]d", vim.diagnostic.goto_next)

			local on_attach = function(client, bufnr)
				-- null-ls handles formatting
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentFormattingProvider = false

				-- Mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
				vim.keymap.set("n", "gh", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
				vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
			end

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local setups = {
				sumneko_lua = function()
					local runtime_path = vim.split(package.path, ";")
					table.insert(runtime_path, "lua/?.lua")
					table.insert(runtime_path, "lua/?/init.lua")
				end,
			}

			local cmds = {
				omnisharp = {
					io.popen("which omnisharp"):read("*a"),
					"--languageserver",
					"--hostPID",
					tostring(vim.fn.getpid()),
				},
			}

			local settings = {
				sumneko_lua = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = vim.api.nvim_get_runtime_file("", true),
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			for _, language_server in pairs(language_servers) do
				print(language_server)
				if setups[language_server] then
					setups[language_server]()
				end

				local setting = settings[language_server]
				local cmd = cmds[language_server]

				if setting and cmd then
					require("lspconfig")[language_server].setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = setting,
						cmd = cmd,
					})
				elseif setting then
					require("lspconfig")[language_server].setup({
						on_attach = on_attach,
						capabilities = capabilities,
						settings = setting,
					})
				elseif cmd then
					require("lspconfig")[language_server].setup({
						on_attach = on_attach,
						capabilities = capabilities,
						cmd = cmd,
					})
				else
					require("lspconfig")[language_server].setup({
						on_attach = on_attach,
						capabilities = capabilities,
					})
				end
			end
		end,
	})

	-- git
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup()
			vim.keymap.set("n", "<leader>g", "<cmd>Neogit<cr>")
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

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
			vim.keymap.set("n", "<leader>dc", dap.continue)
			vim.keymap.set("n", "<leader>du", dap.step_over)
			vim.keymap.set("n", "<leader>di", dap.step_into)
			vim.keymap.set("n", "<leader>do", dap.step_out)
			vim.keymap.set("n", "<leader>dr", dap.repl.open)
		end,
	})
	use({
		"leoluz/nvim-dap-go",
		config = function()
			local dapgo = require("dap-go")

			dapgo.setup()

			-- todo: only do this for .go files with an autocmd
			vim.keymap.set("n", "<leader>dt", dapgo.debug_test)
		end,
	})
	use({
		"rcarriga/nvim-dap-ui",
		requires = {
			"mfussenegger/nvim-dap",
			config = function()
				require("dapiui").setup()
			end,
		},
	})

	-- telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use({ "nvim-telescope/telescope-file-browser.nvim" })
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			local actions = require("telescope.actions")
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<esc>"] = actions.close,
						},
					},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")

			local function find_dotfiles()
				local config_dir = vim.fn.stdpath("config")
				require("telescope.builtin").find_files({ cwd = config_dir })
			end

			local function file_browser_cwd()
				require("telescope").extensions.file_browser.file_browser({ path = vim.fn.expand("%:p:h") })
			end

			vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers)
			vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files)
			vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
			vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
			vim.keymap.set("n", "<leader>fo", require("telescope.builtin").oldfiles)
			vim.keymap.set("n", "<leader>fb", require("telescope.builtin").current_buffer_fuzzy_find)
			vim.keymap.set("n", "<leader>fc", require("telescope.builtin").colorscheme)
			vim.keymap.set("n", "<leader>fp", require("telescope").extensions.file_browser.file_browser)
			vim.keymap.set("n", "<leader>fe", file_browser_cwd)
			vim.keymap.set("n", "<leader>fd", find_dotfiles)
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
			local rep = require("luasnip.extras").rep

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
	})

	-- completion
	use({
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			local lspkind = require("lspkind")
			cmp.setup({
				snippet = {
					-- REQUIRED - you must specify a snippet engine
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
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
				rainbow = {
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
				},
			})

			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.keymap.set("n", "<leader>sr", "<cmd>write | edit | TSBufEnable highlight<cr>")
		end,
	})
	use("nvim-treesitter/nvim-treesitter-textobjects")

	-- commenting
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- debug
	use({
		"tpope/vim-scriptease",
		cmd = {
			"Messages", --view messages in quickfix list
		},
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
	use("machakann/vim-sandwich")
	use("p00f/nvim-ts-rainbow")

	--icons
	use({
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup()
		end,
	})

	-- COLOURSCHEMES

	use("sainnhe/sonokai")
	use("folke/tokyonight.nvim")

	if Packer_bootstrap then
		require("packer").sync()
	end
end)

-- SETTINGS

local colorscheme = "tokyonight-night"

vim.cmd("colorscheme " .. colorscheme)
-- utils.line_number_emphasize()

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
	relativenumber = false,
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

utils.set_variables(globals, vim.g)
utils.set_variables(options, vim.o)

-- KEYMAPS

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
map("n", "<leader>ms", "<cmd>tabnew | term <cr>")

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

-- run  and test file
map("n", "<leader>rr", utils.run_file)
map("n", "<leader>rt", utils.test_file)

-- AUTOCOMMANDS

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "init.lua",
	group = vim.api.nvim_create_augroup("packer_user_config", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.cmd("source % | PackerCompile ")
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

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("ManualFold", { clear = true }),
	command = "normal zx | zi",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.js", "*.jsx", "*.html", "*.ts", "*.tsx", "*.tpl" },
	group = vim.api.nvim_create_augroup("JavascriptFile", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("tabstop", 2, { scope = "local" })
			vim.api.nvim_set_option_value("shiftwidth", 2, { scope = "local" })
		end)
	end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.mdx",
	group = vim.api.nvim_create_augroup("MarkdownXFile", { clear = true }),
	callback = function()
		vim.schedule(function()
			vim.api.nvim_set_option_value("filetype", "markdown", { scope = "local" })
		end)
	end,
})
