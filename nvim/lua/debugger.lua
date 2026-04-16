vim.pack.add({
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/leoluz/nvim-dap-go",
})

local dap = require("dap")

vim.api.nvim_set_hl(0, "DapGreen", { fg = "#9ece6a" })
vim.api.nvim_set_hl(0, "DapRed", { fg = "#b21009" })
vim.api.nvim_set_hl(0, "DapOrange", { fg = "#ff7f00" })
--
vim.fn.sign_define("DapBreakpoint", { texthl = "DapGreen", linehl = "", numhl = "DapGreen" })
vim.fn.sign_define("DapBreakpointRejected", { texthl = "DapRed", linehl = "", numhl = "DapRed" })
vim.fn.sign_define("DapStopped", { texthl = "DapOrange", linehl = "", numhl = "DapOrange" })

vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<F5>", dap.continue)
vim.keymap.set("n", "<F10>", dap.step_over)
vim.keymap.set("n", "<F11>", dap.step_into)
vim.keymap.set("n", "<F12>", dap.step_out)
vim.keymap.set("n", "<leader>dx", dap.terminate)

dap.adapters.coreclr = {
	type = "executable",
	command = "netcoredbg",
	args = { "--interpreter=vscode" },
}

local function stem(name)
	return vim.fs.basename(name):match("(.*)%.")
end

local function find_project_dlls()
	local csproj_files = vim.fs.find(function(name)
		return name:match(".*%.csproj$")
	end, { limit = math.huge, type = "file" })

	local project_names = vim.iter(csproj_files)
		:map(function(csproj_file)
			return stem(csproj_file)
		end)
		:totable()

	local dll_files = vim.fs.find(function(name, path)
		return vim.iter(project_names):any(function(project_name)
			return name:match(project_name .. "%.dll")
				and path:match(project_name)
				and path:match("bin")
				and not path:match("ref")
		end)
	end, { limit = math.huge, type = "file" })

	local dll_file = nil
	vim.ui.select(dll_files, {
		prompt = "Select project to run:",
		format_item = function(item)
			return stem(item) .. " (" .. item .. ")"
		end,
	}, function(choice)
		dll_file = choice
	end)

	return dll_file or dap.ABORT
end

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = find_project_dlls,
	},
}

dap.adapters.codelldb = {
	type = "server",
	port = "${port}",
	executable = {
		command = "codelldb",
		args = { "--port", "${port}" },
	},
}

dap.configurations.rust = {
	{
		type = "codelldb",
		name = "launch - codelldb",
		request = "launch",
		program = function()
			return vim.fn.input({ "Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file" })
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
	},
}

local dapui = require("dapui")

vim.keymap.set("n", "<leader>de", dapui.eval)

-- open dapui automatically
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dapui.setup()

local dapgo = require("dap-go")

dapgo.setup()

vim.keymap.set("n", "<leader>dt", dapgo.debug_test)
