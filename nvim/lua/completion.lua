vim.pack.add({ "https://github.com/saghen/blink.cmp" })

require("blink.cmp").setup({
	cmdline = {
		completion = { menu = { auto_show = true } },
		keymap = {
			["<Tab>"] = { "accept", "fallback" },
			["<Left>"] = {},
			["<Right>"] = {},
		},
	},
	snippets = { preset = "mini_snippets" },
	fuzzy = { implementation = "lua" },
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
