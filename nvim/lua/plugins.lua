-- Packer - plugins

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
end

vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])

-- caching
require("impatient")

require("packer").startup(function(use)
	use("wbthomason/packer.nvim")

	-- FUNCTIONALITY

	use("neovim/nvim-lspconfig")
	use("ludovicchabant/vim-gutentags")
	use("tpope/vim-fugitive")
	use("machakann/vim-sandwich")
	use("jiangmiao/auto-pairs")
	use("p00f/nvim-ts-rainbow")
	use("junegunn/goyo.vim")
	use("kyazdani42/nvim-web-devicons")
	use("numToStr/FTerm.nvim")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("lewis6991/impatient.nvim")
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("neogit").setup()
		end,
	})
	use({
		"startup-nvim/startup.nvim",
		requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("startup").setup()
		end,
	})
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup()
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
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
			}
			null_ls.setup({
				sources = sources,
				on_attach = function(client)
					if client.resolved_capabilities.document_formatting then
						vim.cmd([[
                augroup LspFormatting
                    autocmd! * <buffer>
                    autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                augroup END
                ]])
					end
				end,
			})
		end,
	})
	use({
		"Pocco81/AutoSave.nvim",
		config = function()
			require("autosave").setup({
				enabled = true,
				execution_message = "(autosaved) @ " .. vim.fn.strftime("%H:%M:%S"),
				events = { "InsertLeave", "TextChanged" },
				conditions = {
					exists = true,
					filename_is_not = {},
					filetype_is_not = {},
					modifiable = true,
				},
				write_all_buffers = false,
				on_off_commands = true,
				clean_command_line_interval = 0,
				debounce_delay = 500, -- in ms
			})
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
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
					"lua",
					"css",
				},
			})
			vim.cmd("set foldexpr=nvim_treesitter#foldexpr()")
		end,
	})
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = require("variables").lualinetheme,
					-- component_separators = "|",
					-- section_separators = "",
				},
			})
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.g.indent_blankline_char = "┊"
			vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
			vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
			vim.g.indent_blankline_show_trailing_blankline_indent = false
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
				pickers = {
					find_files = {
						theme = "dropdown",
					},
					buffers = {
						theme = "dropdown",
					},
					live_grep = {
						theme = "dropdown",
					},
					help_tags = {
						theme = "dropdown",
					},
					oldfiles = {
						theme = "dropdown",
					},
					current_buffer_fuzzy_find = {
						theme = "dropdown",
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
	})
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

	-- THEMES

	use("shaunsingh/nord.nvim")
	use("Mofiqul/dracula.nvim")
	use("mjlbach/onedark.nvim")
	use("sjl/badwolf")
	use("tanvirtin/monokai.nvim")
	use("folke/tokyonight.nvim")
	use("morhetz/gruvbox")
	use({ "rose-pine/neovim", as = "rose-pine" })
end)
