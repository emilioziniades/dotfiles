vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.diff").setup()
require("mini.git").setup()
local statusline = require("mini.statusline")

local function statusline_highlight(hl_group, text)
	local x = "%#" .. hl_group .. "#" .. text .. "%*"
	print(x)
	return "%#" .. hl_group .. "#" .. text .. "%*"
end

local function git_status()
	local head = vim.b.minigit_summary and vim.b.minigit_summary.head_name
	if not head then
		return ""
	end

	local parts = { head }

	local diff = vim.b.minidiff_summary or {}
	if diff.add and diff.add > 0 then
		table.insert(parts, statusline_highlight("MiniDiffSignAdd", "+" .. diff.add))
	end
	if diff.delete and diff.delete > 0 then
		table.insert(parts, statusline_highlight("MiniDiffSignDelete", "-" .. diff.delete))
	end
	if diff.change and diff.change > 0 then
		table.insert(parts, statusline_highlight("MiniDiffSignChange", "~" .. diff.change))
	end
	return table.concat(parts, " ")
end

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
				{ hl = "MiniStatuslineDevinfo", strings = { git_status() } },
				{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
				"%<",
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=",
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { progress, location } },
			})
		end,
	},
	use_icons = false,
})
