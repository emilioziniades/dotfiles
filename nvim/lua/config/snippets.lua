local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
local rep = require("luasnip.extras").rep

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

ls.add_snippets("python", {
	-- __name__ __main__
	s("nm", {
		t({ [[if __name__ == "__main__":]], "   main()" }),
	}),
	-- iPython debug
	s("db", {
		t({ "from IPython import embed; embed(colors='neutral')  # fmt: skip" }),
	}),
	-- function definition
	s("df", {
		t("def "),
		i(1),
		t("("),
		i(2),
		t(") -> "),
		i(3),
		t({ ":", "\t" }),
	}),
})

ls.add_snippets("javascript", {
	-- html expansion of the form ".tag.class1.class2" or ".tag." for elements without classes
	s({ trig = ".(%w+).([-.a-zA-Z0-9]*)", regTrig = true }, {
		f(function(_, snip)
			local tag = snip.captures[1]
			local class = snip.captures[2]:gsub("[.]", " ")
			if class == "" then
				return string.format([[<%s>]], tag)
			else
				return string.format([[<%s className="%s">]], tag, class)
			end
		end),
		i(0),
		f(function(_, snip)
			local tag = snip.captures[1]
			return string.format([[</%s>]], tag)
		end),
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
