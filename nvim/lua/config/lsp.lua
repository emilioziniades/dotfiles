--convenience keymap function
local function map(mode, lhs, rhs, more_opts)
	local opts = { noremap = true, silent = true }
	more_opts = more_opts or {}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_deep_extend("force", opts, more_opts))
end

-- general keymaps
map("n", "<space>d", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- keymaps only after language server attaches to current buffer
local function on_attach(client, bufnr)
	--disable formatting, to be handled by null-ls
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
	-- map("n", "<leader>f", vim.lsp.buf.formatting(), { buffer = bufnr })
end

-- set up language servers

local servers = { "pyright", "gopls", "tsserver", "rls", "omnisharp" }
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in pairs(servers) do
	require("lspconfig")[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- set up sumneko_lua

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require("lspconfig").sumneko_lua.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = runtime_path,
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
})
