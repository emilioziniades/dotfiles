local iron = require("iron.core")
local bracketed_paste = require("iron.fts.common").bracketed_paste

-- copied from iron.fts.python
local def = function(cmd)
	return {
		command = cmd,
		format = bracketed_paste,
	}
end

iron.setup({
	config = {
		highlight_last = false,
		repl_open_cmd = "vertical bo split",
		should_map_plug = false,
		scratch_repl = true,
		buflisted = true,
		repl_definition = {
			-- python = require("iron.fts.python").ipython,
			python = def({ "ipython", "--no-autoindent", "--no-confirm-exit" }),
		},
	},
	keymaps = {
		send_motion = "<space>rc",
		visual_send = "<space>rc",
		send_line = "<space>rl",
		cr = "<space>s<cr>",
		interrupt = "<space>s<space>",
		exit = "<space>rq",
		clear = "<space>cl",
	},
})

local function run_file_repl()
	require("iron").core.send(vim.bo.ft, vim.fn.readfile(vim.fn.expand("%")))
end

local function start_repl()
	require("iron.core").repl_for(vim.bo.ft)
end

vim.keymap.set("n", "<leader>rr", run_file_repl)
vim.keymap.set("n", "<leader>rs", start_repl)
vim.keymap.set("n", "<leader>rt", iron.repl_restart)
