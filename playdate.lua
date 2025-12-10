--------------------------------------------------------------------------
-- Playdate
--------------------------------------------------------------------------
vim.api.nvim_create_user_command("PlaydateNew", function(args)
	local projectName = args.fargs[1] or "."
	local command = table.concat({
		"terminal",
		"pd.sh",
		"new",
		projectName,
	}, " ")
	vim.cmd(command)
	vim.cmd("startinsert")
end, { nargs = 1 })

vim.api.nvim_create_user_command("PlaydateRun", function(args)
	local dir = args.fargs[1] or "."
	vim.system({ "pd.sh", "-d", dir, "run" })
end, { nargs = "?" })

local TerminalCommands = {
	build = "Build",
	stop = "Stop",
	restart = "Restart",
}
for cmd, capitalized in pairs(TerminalCommands) do
	vim.api.nvim_create_user_command("Playdate" .. capitalized,
		function(args)
			local dir = args.fargs[1] or "."
			local command = table.concat({
				"terminal",
				"pd.sh",
				"-d",
				dir,
				cmd,
			}, " ")
			vim.cmd(command)
			vim.cmd("startinsert")
		end, { nargs = "?" })
end

-- vim.keymap.set({ "i", "n", "v" }, "<F9>", "<cmd>PlaydateRun<cr>")
-- vim.keymap.set({ "i", "n", "v" }, "<F9>", "<cmd>PlaydateBuild<cr>")
vim.keymap.set({ "i", "n", "v" },
	"<F10>",
	"<cmd>w<cr><cmd>PlaydateRun<cr>"
)
