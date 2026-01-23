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
			-- remove existing leading line numbers
			local stripped = line:gsub("^%s*%d+%s*", "")
			table.insert(new_lines, string.format("%04d %s", number, stripped))
			number = number + step
		end
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
end

-- expose function globally (needed for keymap callback)
_G.renumber_basic_lines = renumber_basic_lines
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
		-- Auto increment line numbers
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
		vim.keymap.set(
			"n",
			"<leader>ln",
			renumber_basic_lines,
			{ buffer = true, desc = "Renumber BASIC lines" }
		)
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
