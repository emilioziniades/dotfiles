local iron = require("iron.core")

iron.setup({
	config = {
		highlight_last = "IronLastSent",
		repl_open_cmd = "vertical bo split",
		should_map_plug = false,
		scratch_repl = true,
		repl_definition = {
			python = require("iron.fts.python").ipython,
			-- go = { gore = { command =  "gore"  } },
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

-- iron.add_repl_definitions {
--   go = {
--     gore = {
--       command = {"gore"}
--     }
--   }
-- }
--
-- iron.set_config {
--   preferred = {
--     go = "gore",
--   }
-- }
local function run_file_repl()
	require("iron").core.send(vim.bo.ft, vim.fn.readfile(vim.fn.expand("%")))
end

local function start_repl()
	require("iron.core").repl_for(vim.bo.ft)
end

vim.keymap.set("n", "<leader>rr", run_file_repl)
vim.keymap.set("n", "<leader>rs", start_repl)
