vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.diff").setup()
require("mini.git").setup()
local statusline = require("mini.statusline")

local function create_diff_highlights()
	local bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineDevinfo" }).bg
	vim.api.nvim_set_hl(0, "StatuslineDiffAdd", { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticOk" }).fg, bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineDiffDelete", { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg, bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineDiffChange", { fg = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg, bg = bg })
end

create_diff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = create_diff_highlights })

local function statusline_highlight(hl_group, text)
	return "%#" .. hl_group .. "#" .. text .. "%#MiniStatuslineDevinfo#"
end

-- customize mini.git summary to only show branch name
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniGitUpdated",
	callback = function(args)
		local summary = vim.b[args.buf].minigit_summary
		vim.b[args.buf].minigit_summary_string = summary and summary.head_name or ""
	end,
})

-- customize mini.diff summary with colored counts
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniDiffUpdated",
	callback = function(args)
		local diff = vim.b[args.buf].minidiff_summary or {}
		local parts = {}
		if (diff.add or 0) > 0 then
			table.insert(parts, statusline_highlight("StatuslineDiffAdd", "+" .. diff.add))
		end
		if (diff.delete or 0) > 0 then
			table.insert(parts, statusline_highlight("StatuslineDiffDelete", "-" .. diff.delete))
		end
		if (diff.change or 0) > 0 then
			table.insert(parts, statusline_highlight("StatuslineDiffChange", "~" .. diff.change))
		end
		vim.b[args.buf].minidiff_summary_string = table.concat(parts, " ")
	end,
})

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = "%l:%-2v"
			local progress = "%2p%%"
			local filename = "%f%m%r"

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { string.upper(mode) } },
				{
					hl = "MiniStatuslineDevinfo",
					strings = {
						statusline.section_git({ trunc_width = 40 }),
						statusline.section_diff({ trunc_width = 75, icon = "" }),
					},
				},
				{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { progress, location } },
			})
		end,
	},
	use_icons = true,
})
