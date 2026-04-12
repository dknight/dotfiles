--------------------------------------------------------------------------
-- NES/Famicom
--------------------------------------------------------------------------
vim.filetype.add({
	extension = {
		s = "asm_ca65",
		asm = "asm_ca65",
	},
})
local type = "nes"
local emulator = "fceux"
local compiler = "ca65"
local linker = "cl65"
local compile = string.format("<cmd>!%s %% -o %%<.o<cr>", compiler)
local link = string.format(
	"<cmd>!%s -t %s %%<.o -o %%<.nes<cr>",
	linker,
	type
)
local emulate = "<cmd>!" .. emulator .. " %<.nes"

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "asm_ca65" },
	callback = function(args)
		vim.g.asmsyntax = "ca65"
		vim.cmd("hi asm_ca65HexNumber ctermfg=12")
		vim.keymap.set(
			"n",
			"<f5>",
			"<cmd>w<cr>" .. compile,
			{ buffer = args.buf }
		)
		vim.keymap.set(
			"n",
			"<f6>",
			"<cmd>w<cr>" .. link,
			{ buffer = args.buf }
		)
		vim.keymap.set(
			"n",
			"<f10>",
			compile .. "<cr>" .. link .. "<cr>" .. emulate .. "<cr>",
			{ buffer = args.buf }
		)
	end,
})
