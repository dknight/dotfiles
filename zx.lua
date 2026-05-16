--------------------------------------------------------------------------
-- ZX Spectrum (BASIC)
--------------------------------------------------------------------------

-- ZX emulator. Here I use fbzx; replace it if needed.
local zxEmulator = "fbzx"

--------------------------------------------------------------------------
-- BASIC helpers
--------------------------------------------------------------------------
local function get_bas_file()
	return vim.api.nvim_buf_get_name(0)
end

local function get_tap_file()
	return get_bas_file():gsub("%.bas$", ".tap")
end

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

local function build_basic()
	local build = vim.system(
		{ "zmakebas", "-a", "10", get_bas_file() },
		{ text = true }
	):wait()
	if build.code ~= 0 then
		vim.notify(build.stderr, vim.log.levels.ERROR)
	else
		vim.notify(get_tap_file() .. " build successful")
	end
	return build
end

local function run_zx()
	vim.notify("Emulation running...")
	vim.system({
		"sh",
		"-c",
		string.format([[
			fbzx -nosound "%s" &
			sleep 3
			xdotool search --sync --name FBZX windowactivate
			sleep 0.3
			xdotool key j
			sleep 0.2
			xdotool keydown Control_L
			xdotool key p
			xdotool keyup Control_L
			sleep 0.1
			xdotool keydown Control_L
			xdotool key p
			xdotool keyup Control_L
			sleep 0.2
			xdotool key Return
			sleep 0.2
			xdotool key r
			xdotool key Return
		]], get_tap_file()),
	}, {
		detach = true,
	})
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
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 8
		vim.opt_local.shiftwidth = 8
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
		vim.keymap.set("n", "<F9>", function()
			vim.cmd("w")
			build_basic()
		end, {
			desc = "Build BASIC program",
		})

		------------------------------------------------------------------
		-- Build + Run
		------------------------------------------------------------------
		vim.keymap.set("n", "<F10>", function()
			vim.cmd("w")
			local build = build_basic()
			if build.code == 0 then
				run_zx()
			end
		end, {
			desc = "Build and run BASIC program",
		})
	end,
})

--------------------------------------------------------------------------
-- BASIC formatting before save
--------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "basic",

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
