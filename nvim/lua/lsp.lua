vim.pack.add({
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/folke/trouble.nvim",
	"https://github.com/Decodetalkers/csharpls-extended-lsp.nvim",
})

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
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

local language_servers = {
	pyright = {},
	ruff = {},
	gopls = {},
	ts_ls = {},
	rust_analyzer = {},
	hls = {},
	terraformls = {},
	elixirls = {},
	nil_ls = {
		settings = {
			["nil"] = {
				nix = {
					flake = {
						autoArchive = true,
					},
				},
			},
		},
	},
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

	vim.lsp.config(language_server, language_server_config)
	vim.lsp.enable(language_server)
end

vim.keymap.set("n", "<leader>tt", "<cmd>Trouble<cr>")
