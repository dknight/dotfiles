--------------------------------------------------------------------------
-- ZX Spectrum
--------------------------------------------------------------------------
-- ZX emulator. Here I use fbzx; replace it if you different one.
local zxEmulator = "fbzx"

-- Command to run the zmakebas compiler.
local zmakebasCmd = "<cmd>!zmakebas -o %<.tap %"

-- Command to run the emulator. It may differ for other emulators;
-- adjust as needed.
local zxCmd = "<cmd>!" .. zxEmulator .. " %<.tap"

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "basic" },
	callback = function(args)
		-- In BASIC, we usually type line numbers manually.
		-- Set this to true if you want automatic line numbering,
		-- during compilation.
		vim.opt.number = false

		-- Map the F5 key to save and compile.
		vim.keymap.set(
			"n",
			"<f5>",
			"<cmd>w<cr>" .. zmakebasCmd .. "<cr>"
		)

		-- Map the F6 key to save, compile and run.
		vim.keymap.set(
			"n",
			"<f6>",
			zmakebasCmd .. "<cr>" .. zxCmd .. "<cr>"
		)
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "basic" },
	callback = function(_)
		-- Rest of the keymaps from above

		-- Auto increment line numbers
		local autoincrement = function(opts)
			local newline = opts.newline or false
			local line = vim.api.nvim_get_current_line()
			local num = line:match("^%s*(%d+)")
			if not num then
				return "\n"
			end

			local prev = tonumber(num)
			local row = vim.api.nvim_win_get_cursor(0)[1]
			local step = 10

			if row > 1 then
				local prevline = vim.api.nvim_buf_get_lines(
					0, row - 2, row - 1, false
				)[1]
				local pnum = prevline:match("^%s*(%d+)")
				if pnum then
					pnum = tonumber(pnum)
					step = prev - pnum
				end
			end

			return string.format(
				"%s\n%d\t",
				newline and "\n" or "",
				prev + step
			)
		end
		vim.keymap.set(
			"i", "<CR>",
			function()
				return autoincrement({ newline = false })
			end,
			{ buffer = true, expr = true }
		)
		vim.keymap.set("n", "o", function()
			local text = autoincrement({ newline = true })
			local lines = {}
			for line in text:gmatch("([^\n]*)\n?") do
				if line ~= "" then table.insert(lines, line) end
			end
			vim.api.nvim_put(lines, "l", true, true)
			vim.cmd("startinsert!")
		end, { noremap = true })
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*.bas",
	callback = function()
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for i, line in ipairs(lines) do
			lines[i] = line:gsub("^(%d+)%s*", "%1\t")
		end
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	end,
})
