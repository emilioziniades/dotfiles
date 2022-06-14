local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

ls.add_snippets("all", {
	s("nm", {
		t({ [[if __name__ == "__main__":]], "   main()" }),
	}),
})
ls.add_snippets("all", {
	s("db", {
		t({ "from IPython import embed; embed(colors='neutral')  # fmt: skip" }),
	}),
})

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
