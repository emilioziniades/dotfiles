vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.diff").setup()
require("mini.git").setup()
local statusline = require("mini.statusline")

-- create diff colours for statusline
local function create_diff_highlights()
	local function get_bg(hl_group)
		return vim.api.nvim_get_hl(0, { name = hl_group }).bg
	end

	local function get_fg(hl_group)
		return vim.api.nvim_get_hl(0, { name = hl_group }).fg
	end

	local bg = get_bg("MiniStatuslineDevinfo")
	vim.api.nvim_set_hl(0, "StatuslineDiffAdd", { fg = get_fg("DiagnosticOk"), bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineDiffDelete", { fg = get_fg("DiagnosticError"), bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineDiffChange", { fg = get_fg("DiagnosticWarn"), bg = bg })
end

create_diff_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("StatuslineDiffHighlights", { clear = true }),
	callback = create_diff_highlights,
})

-- set custom git summary for statusline
-- literally just show the branch name
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("StatuslineGitSummary", { clear = true }),
	pattern = "MiniGitUpdated",
	callback = function(args)
		local summary = vim.b[args.buf].minigit_summary
		vim.b[args.buf].minigit_summary_string = summary and summary.head_name or ""
	end,
})

-- set custom diff summary for statusline
-- use the highlight groups created above to show +2 -1 ~3 in different colours
vim.api.nvim_create_autocmd("User", {
	group = vim.api.nvim_create_augroup("StatuslineDiffSummary", { clear = true }),
	pattern = "MiniDiffUpdated",
	callback = function(args)
		local diff = vim.b[args.buf].minidiff_summary or {}

		local function statusline_highlight(hl_group, text)
			return "%#" .. hl_group .. "#" .. text .. "%#MiniStatuslineDevinfo#"
		end

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
			local icon, _ = require("mini.icons").get("filetype", vim.bo.filetype)
			local fileinfo = icon .. " " .. vim.bo.filetype .. " " .. vim.bo.fileencoding

			local filename = "%f%m%r"
			local progress = "%2p%%"
			local location = "%l:%-2v"

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
