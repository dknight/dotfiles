--------------------------------------------------------------------------
-- ZX Spectrum (BASIC)
--------------------------------------------------------------------------

-- ZX emulator. Here I use fbzx; replace it if needed.
local zxEmulator = "fbzx"

-- Commands
local zmakebasCmd = "!zmakebas -o %<.tap %"
local zxCmd = "!" .. zxEmulator .. " %<.tap"

--------------------------------------------------------------------------
-- BASIC helpers
--------------------------------------------------------------------------
local function renumber_basic_lines()
	local bufnr = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local new_lines = {}
	local number = 10
	local step = 10

	for _, line in ipairs(lines) do
		if line:match("^%s*$") then
			table.insert(new_lines, line)
		else
			-- Remove existing leading line numbers
			local stripped = line:gsub("^%s*%d+%s*", "")

			table.insert(
				new_lines,
				string.format("%04d %s", number, stripped)
			)

			number = number + step
		end
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

--------------------------------------------------------------------------
-- BASIC filetype config
--------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "basic",

	callback = function(args)
		------------------------------------------------------------------
		-- Local options
		------------------------------------------------------------------
		vim.opt_local.number = false

		------------------------------------------------------------------
		-- Auto increment line numbers
		------------------------------------------------------------------
		local autoincrement = function(opts)
			local newline = opts.newline or false

			local line = vim.api.nvim_get_current_line()
			local num = line:match("^%s*(%d+)")

			if not num then
				return "\n"
			end

			local prev = tonumber(num)
			local step = 10

			return string.format(
				"%s\n%04d",
				newline and "\n" or "",
				prev + step
			)
		end

		------------------------------------------------------------------
		-- Insert mode Enter
		------------------------------------------------------------------
		vim.keymap.set(
			"i",
			"<CR>",
			function()
				return autoincrement({ newline = false })
			end,
			{
				buffer = args.buf,
				expr = true,
			}
		)

		------------------------------------------------------------------
		-- Normal mode "o"
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"o",
			function()
				local text = autoincrement({ newline = true })
				local lines = {}

				for line in text:gmatch("([^\n]*)\n?") do
					if line ~= "" then
						table.insert(lines, line)
					end
				end

				vim.api.nvim_put(lines, "l", true, true)
				vim.cmd("startinsert!")
			end,
			{
				buffer = args.buf,
			}
		)

		------------------------------------------------------------------
		-- Renumber lines
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"<leader>ln",
			renumber_basic_lines,
			{
				buffer = args.buf,
				desc = "Re-number BASIC lines",
			}
		)

		------------------------------------------------------------------
		-- Build
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"<F9>",
			"<cmd>w<cr><cmd>" .. zmakebasCmd .. "<cr>",
			{
				buffer = args.buf,
				desc = "Build BASIC program",
			}
		)

		------------------------------------------------------------------
		-- Build + Run
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"<F10>",
			"<cmd>w<cr>"
			.. "<cmd>" .. zmakebasCmd .. "<cr>"
			.. "<cmd>" .. zxCmd .. "<cr>",
			{
				buffer = args.buf,
				desc = "Build and run BASIC program",
			}
		)
	end,
})

--------------------------------------------------------------------------
-- BASIC formatting before save
--------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.bas",

	callback = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^(%d+)%s*", "%1\t")
		end

		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end,
})

--------------------------------------------------------------------------
-- ZX Spectrum ASM (sjasmplus)
--------------------------------------------------------------------------
local sjasmplusCmd = "!sjasmplus %"
local zxAsmRunCmd = "!" .. zxEmulator .. " %<.tap"

--------------------------------------------------------------------------
-- Z80 filetype config
--------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
	pattern = "asm",
	callback = function(args)
		------------------------------------------------------------------
		-- Local options
		------------------------------------------------------------------
		vim.opt_local.number = true
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 8
		vim.opt_local.shiftwidth = 8

		------------------------------------------------------------------
		-- Build
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"<F9>",
			"<cmd>w<cr><cmd>" .. sjasmplusCmd .. "<cr>",
			{
				buffer = args.buf,
				desc = "Assemble Z80 source",
			}
		)

		------------------------------------------------------------------
		-- Build + Run
		------------------------------------------------------------------
		vim.keymap.set(
			"n",
			"<F10>",
			"<cmd>w<cr>"
			.. "<cmd>" .. sjasmplusCmd .. "<cr>"
			.. "<cmd>" .. zxAsmRunCmd .. "<cr>",
			{
				buffer = args.buf,
				desc = "Assemble and run Z80 program",
			}
		)
	end,
})
