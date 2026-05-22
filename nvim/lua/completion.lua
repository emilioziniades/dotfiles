vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("blink-cmp-build", { clear = true }),
	callback = function(ev)
		local name, kind, path = ev.data.spec.name, ev.data.kind, ev.data.path
		if name == "blink.cmp" and kind ~= "delete" then
			return
		end
		local result = vim.system({ "cargo", "build", "--release" }, { cwd = path }):wait()
		if result.code ~= 0 then
			error("blink.cmp cargo build failed (exit " .. result.code .. "):\n" .. (result.stderr or ""))
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
})

require("blink.cmp").setup({
	cmdline = {
		completion = { menu = { auto_show = true } },
		keymap = {
			["<Tab>"] = { "select_next" },
			["<S-Tab>"] = { "select_prev" },
			["<Left>"] = {},
			["<Right>"] = {},
		},
	},
	snippets = { preset = "mini_snippets" },
	fuzzy = {
		sorts = { "exact", "score", "sort_text" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			cmdline = {
				min_keyword_length = 2,
			},
		},
	},
	completion = {
		documentation = { auto_show = true },
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
					{ "kind_icon", "kind", gap = 1 },
					{ "source_name" },
				},
				components = {
					source_name = {
						text = function(ctx)
							local labels = {
								lsp = "[LSP]",
								buffer = "[buf]",
								snippets = "[snip]",
								path = "[path]",
								cmdline = "[cmd]",
							}
							return labels[ctx.source_id] or ctx.source_name
						end,
					},
				},
			},
		},
	},
})
