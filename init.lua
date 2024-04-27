local homedir = vim.fn.expand("$HOME")
-- local uname = vim.fn.system("uname -s")
if vim.o.term:find("256color") then
	vim.go.t_ut = true
end
vim.g.mapleader = ","
vim.opt.exrc = false
vim.opt.secure = true
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.omnifunc = "syntaxcomplete#Complete"
vim.opt.spelllang = "en_us"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.clipboard = "unnamed"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
-- vim.opt.expandtab = false
vim.opt.smartindent = true
vim.opt.list = true
vim.opt.ignorecase = true
vim.opt.infercase = true
vim.opt.smartcase = true
vim.opt.listchars = { tab = "⏵ ", trail = "." } -- , eol = "$"
vim.opt.rulerformat = "%l,%v"
vim.opt.colorcolumn = "75,79"
vim.opt.undofile = true
vim.opt.undodir = homedir .. "/.undodir"
vim.opt.lazyredraw = false
vim.opt.textwidth = 78
vim.opt.endoffile = true

-------------------------- ctags -----------------------------------------
-- Use correct patterns if needed
-- vim.api.nvim_create_autocmd({"BufWritePost"}, {
-- pattern = {"*"},
--	command = vim.fn.system("ctags -R"),
-- })
-------------------------- Commands --------------------------------------
-- Share the code with https://sprunge.us
vim.cmd([[
command! -nargs=0 -bar Share execute "!cat % | curl -F "sprunge=<-" http://sprunge.us"
]])

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "sh" },
	callback = function(args)
		vim.keymap.set("n", "<f5>", ":w<cr>:!%%%<cr>")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "html,xml,css,json" },
	callback = function(args)
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.expandtab = true
		vim.cmd("EmmetInstall")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua" },
	callback = function()
		vim.opt.shiftwidth = 4
		vim.opt.softtabstop = 4
		vim.keymap.set("n", "<f5>", ":w<cr>:!lua %<cr>")
		vim.keymap.set("n", "<f8>", ":w<cr>:!love %<cr>")
		vim.cmd("iab <expr> kv 'print(k, v)'")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
		vim.cmd([[silent! %s/\s\+$//e]])
		vim.cmd([[silent! !stylua %]])
	end,
})

--------------------- Generic  Abbreviations -----------------------------
vim.cmd("iab <expr> date! system('date +%Y-%m-%d')")
vim.cmd("iab <expr> datetime! system('date --rfc-3339=seconds')")

-------------------------- Mappings --------------------------------------
vim.keymap.set("n", "<c-s>", "<cmd>write<cr>")
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set({ "i", "n", "v" }, "<up>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<down>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<left>", "<nop>")
vim.keymap.set({ "i", "n", "v" }, "<right>", "<nop>")
vim.keymap.set("n", "<leader>b", "<cmd>bd!<cr>")
vim.keymap.set("n", "[b", "<cmd>bprev<cr>", { silent = true })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { silent = true })
vim.keymap.set("n", "[B", "<cmd>bfirst<cr>", { silent = true })
vim.keymap.set("n", "]B", "<cmd>blast<cr>", { silent = true })
vim.keymap.set("n", "[c", "<cmd>cprev<cr>", { silent = true })
vim.keymap.set("n", "]c", "<cmd>cnext<cr>", { silent = true })
vim.keymap.set("n", "[C", "<cmd>cfirst<cr>", { silent = true })
vim.keymap.set("n", "]C", "<cmd>clast<cr>", { silent = true })
vim.keymap.set("n", "[t", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "]t", "<cmd>tabprev<cr>", { silent = true })
vim.keymap.set("n", "[T", "<cmd>tabfirst<cr>", { silent = true })
vim.keymap.set("n", "]T", "<cmd>tablast<cr>", { silent = true })
vim.keymap.set("n", "<leader>T", "<cmd>tabnew<cr>", { silent = true })
vim.keymap.set("n", "<leader>j", "<cmd>m.+1<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>m.-2<cr>")
vim.keymap.set({ "n", "i" }, "<leader>;", "A;<esc>")
vim.keymap.set({ "n", "i" }, "<leader>,", "A,<esc>")
vim.keymap.set({ "n", "x" }, "&", "<cmd>&&<esc>")
vim.keymap.set("n", "<c-l>", "<cmd>set hlsearch!<cr>")
vim.keymap.set("c", "%%", '<c-r>=fnameescape(expand("%:h"))."/"<cr>')
vim.keymap.set("n", "<leader>s", ":setlocal spell!<cr>")
-------------------------- Plugins ---------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	-- Common
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"tpope/vim-abolish",
	"vim-airline/vim-airline",
	"vim-airline/vim-airline-themes",
	"ctrlpvim/ctrlp.vim",
	"Yggdroot/indentLine",
	"jiangmiao/auto-pairs",
	"nelstrom/vim-visual-star-search",
	"dhruvasagar/vim-table-mode",
	"flazz/vim-colorschemes",
	"neovim/nvim-lspconfig",
	"neoclide/coc.nvim",
	"ckipp01/stylua-nvim", -- npm i -g @johnnymorganz/stylua-bin
	-- Go
	-- "fatih/vim-go",
	-- Web
	-- "mattn/emmet-vim",
	-- "vim-scripts/loremipsum",
	-- text
	"rhysd/vim-grammarous",
	-- "dpelle/vim-LanguageTool"
}

-- languagetool
-- https://languagetool.org/download/
-- vim.g.languagetool_cmd="java -jar $HOME/.config/LanguageTool-5.9/languagetool-commandline.jar"
vim.g["grammarous#jar_url"] = "https://www.languagetool.org/download/LanguageTool-5.9.zip"

-- Aurline
vim.g.airline_theme = "serene"
vim.g.airline_powerline_fonts = 0
vim.g.airline_symbols = {
	maxlinenr = "",
	colnr = ":",
	linenr = " ",
}

-- Emmet
vim.g.user_emmet_leader_key = "<C-y>"
vim.g.user_emmet_install_global = 0

-- Vim surround
vim.g.surround_indent = 1

-- CtrlP
vim.g.wildignore = "*/node_modules/*,*.so,*.swp,*.zip,*.git,*.o,*.a,"

-- netrw
vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 100
vim.g.netrw_altv = 1
vim.keymap.set({ "n", "i" }, "<c-g>", "<cmd>Vex<cr>")

require("lazy").setup(plugins, opts)

-- Colors
vim.cmd.colorscheme("wasabi256")
vim.cmd([[
	highlight NonText ctermbg=None ctermfg=238
]])

-- TODO make function to swith to russian.
--et spelllang=ru_ru
--set keymap=russian-jcuken
-- TODO contribute estonian language (when free time or ask help)
-- http://ftp.vim.org/vim/runtime/spell/README.txt
