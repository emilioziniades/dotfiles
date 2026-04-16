vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

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
		xml = { "csharpier" },
		fsharp = { "fantomas" },
		nix = { "nixfmt" },
		terraform = { "tofu_fmt" },
		hcl = { "tofu_fmt" },
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
		elixir = { "mix" },
	},
	formatters = {
		scheme_format = {
			command = "scheme-format",
			args = { "-i", "$FILENAME" },
			stdin = false,
		},
		csharpier = {
			command = "csharpier",
			args = { "format", "--write-stdout" },
		},
	},
})
