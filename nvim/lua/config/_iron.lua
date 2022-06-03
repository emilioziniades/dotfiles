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
		send_motion = "<space>sc",
		visual_send = "<space>sc",
		send_line = "<space>sl",
		cr = "<space>s<cr>",
		interrupt = "<space>s<space>",
		exit = "<space>sq",
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
