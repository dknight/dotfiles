local homedir = vim.fn.expand("$HOME")
local stylua_cfg = homedir .. "/lab/dotfiles/.stylua.toml"

-- local uname = vim.fn.system("uname -s")
vim.g.mapleader = ","
vim.opt.exrc = false
vim.opt.secure = true
vim.opt.number = true
vim.opt.mouse = ""
-- vim.opt.omnifunc = "syntaxcomplete#Complete"
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
-- vim.cmd([[
-- command! -nargs=0 -bar Share execute "!cat % | curl -F "sprunge=<-" http://sprunge.us"
-- ]])

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "sh" },
	callback = function(args)
		vim.keymap.set("n", "<f5>", "<cmd>w<cr><cmd>!%%%<cr>")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "html,xml,css" },
	callback = function(args)
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.expandtab = true
		-- vim.cmd("EmmetInstall")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "lua" },
	callback = function()
		vim.keymap.set("n", "<f5>", "<cmd>w<cr><cmd>!lua %<cr>")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
		local stylua_cmd = "silent! !stylua --config-path="
			.. stylua_cfg
			.. " %"
		vim.cmd([[silent! %s/\s\+$//e]])
		vim.cmd(stylua_cmd)
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
-------------------------- Plugins --------------------------------------
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
	"neovim/nvim-lspconfig",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"vim-airline/vim-airline",
	"vim-airline/vim-airline-themes",
	"ctrlpvim/ctrlp.vim",
	"jiangmiao/auto-pairs",
	"nelstrom/vim-visual-star-search",
	"dhruvasagar/vim-table-mode",
	"flazz/vim-colorschemes",
	"neoclide/coc.nvim",
	"nvim-treesitter/nvim-treesitter", --run :TSInstall
	-- lua
	"dcampos/nvim-snippy",
	{
		"S1M0N38/love2d.nvim",
		cmd = "LoveRun",
		opts = {},
		keys = {
			{ "<leader>v", desc = "LÖVE" },
			{ "<f6>", "<cmd>w<cr><cmd>LoveRun<cr>", desc = "Run LÖVE" },
			{ "<f7>", "<cmd>LoveStop<cr>", desc = "Stop LÖVE" },
		},
	},
	-- Go
	-- "fatih/vim-go",
	-- Web
	-- "mattn/emmet-vim",
	-- "vim-scripts/loremipsum",
}

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

require("lazy").setup(plugins, {})
require("snippy").setup({
	mappings = {
		is = {
			["<C-K>"] = "expand_or_advance",
			["<C-S-K>"] = "previous",
		},
		nx = {
			["<leader>x"] = "cut_text",
		},
	},
})

-- Colors
vim.cmd.colorscheme("wasabi256")
vim.cmd([[
	highlight NonText ctermbg=None ctermfg=238
]])

-- LSP
require("lspconfig").lua_ls.setup({
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if
			vim.loop.fs_stat(path .. "/.luarc.json")
			or vim.loop.fs_stat(path .. "/.luarc.jsonc")
		then
			return
		end

		client.config.settings.Lua =
			vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using
					-- (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						-- Depending on the usage, you might want to add additional paths here.
						"${3rd}/love2d/library",
						-- "${3rd}/busted/library",
					},
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				},
			})
	end,
	settings = {
		Lua = {
			runtime = {
				version = "Lua 5.4",
			},
		},
	},
})

-- TODO make function to swith to russian.
--et spelllang=ru_ru
--set keymap=russian-jcuken
-- TODO contribute estonian language (when free time or ask help)
-- http://ftp.vim.org/vim/runtime/spell/README.txt
