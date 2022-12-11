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
