local language_servers = { "pyright", "gopls", "tsserver", "rls", "sumneko_lua", "omnisharp" }

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = language_servers,
})

local map = require("utils").map

map("n", "<space>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

local on_attach = function(client, bufnr)
	-- null-ls handles formatting
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false

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

for _, language_server in pairs(language_servers) do
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
