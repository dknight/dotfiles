--------------------------------------------------------------------------
-- NES/Famicom
--------------------------------------------------------------------------
local type = "nes"
local emulator = "fceux"
local compiler = "ca65"
local linker = "cl65"
local compile = string.format("<cmd>!%s %% -o %%<.o", compiler)
local link = string.format("<cmd>!%s -t %s %%<.o -o %%<.nes", linker, type)
local emulate = "<cmd>!" .. emulator .. " %<.nes"

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "asm" },
	callback = function(args)
		vim.keymap.set(
			"n",
			"<f5>",
			"<cmd>w<cr>" .. compile .. "<cr>"
		)
		vim.keymap.set(
			"n",
			"<f6>",
			"<cmd>w<cr>" .. link .. "<cr>"
		)
		vim.keymap.set(
			"n",
			"<f10>",
			"<cmd>w<cr>" ..
			compile .. "<cr>" .. link .. "<cr>" .. emulate .. "<cr>"
		)
	end,
})
