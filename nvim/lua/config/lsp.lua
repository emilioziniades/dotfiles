local language_servers = { "pyright", "gopls", "tsserver", "rls", "sumneko_lua", "omnisharp" }

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = language_servers,
})

local map = require("utils").map

map("n", "<space>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

local function on_attach(client, bufnr)
	-- null-ls handles formatting
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false

	map("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr })
	map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
	map("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
	map("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr })
	map("n", "gh", vim.lsp.buf.signature_help, { buffer = bufnr })
	map("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = bufnr })
	map("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr })
	map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr })
	map("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local setups = {
	sumneko_lua = function()
		local runtime_path = vim.split(package.path, ";")
		table.insert(runtime_path, "lua/?.lua")
		table.insert(runtime_path, "lua/?/init.lua")
	end,
}

local cmds = {
	omnisharp = { io.popen("which omnisharp"):read("*a"), "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
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

-- TODO: ensure settings and cmds don't overwrite defaults
for _, language_server in pairs(language_servers) do
	if setups[language_server] then
		setups[language_server]()
	end
	-- local setting = settings[language_server] or {}
	-- local cmd = cmds[language_server] or {}
	require("lspconfig")[language_server].setup({
		on_attach = on_attach,
		capabilities = capabilities,
		-- settings = setting,
		-- cmd = cmd,
	})
end
