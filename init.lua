-------------------------------------------------------------------------------
-- Locals
-------------------------------------------------------------------------------

-- local uname = vim.fn.system("uname -s")
local homedir = vim.fn.expand("$HOME")


-------------------------------------------------------------------------------
-- Lazy setup
-------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)


-------------------------------------------------------------------------------
-- Vim options
--
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-------------------------------------------------------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"
vim.opt.exrc = false
vim.opt.secure = true
vim.opt.number = true
vim.opt.mouse = ""
vim.opt.spelllang = "en_us"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.clipboard = "unnamedplus"
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


-------------------------------------------------------------------------------
-- ctags
-------------------------------------------------------------------------------
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


-------------------------------------------------------------------------------
-- Auto commands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*.sh" },
	callback = function(args)
		vim.keymap.set("n", "<f5>", "<cmd>w<cr><cmd>!%%%<cr>")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*.html,*.xml,*.css" },
	callback = function(args)
		vim.opt.shiftwidth = 2
		vim.opt.softtabstop = 2
		vim.opt.expandtab = true
		-- vim.cmd("EmmetInstall")
	end,
})
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "*.lua" },
	callback = function()
		vim.keymap.set("n", "<f5>", "<cmd>w<cr><cmd>!lua %<cr>")
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = { "*.lua" },
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})


-------------------------------------------------------------------------------
-- Common abbreviations
-------------------------------------------------------------------------------
vim.cmd("iab <expr> date! system('date +%Y-%m-%d')")
vim.cmd("iab <expr> datetime! system('date --rfc-3339=seconds')")


-------------------------------------------------------------------------------
-- Colors
-------------------------------------------------------------------------------
vim.cmd.colorscheme("habamax")
vim.cmd([[
	highlight NonText ctermbg=None ctermfg=238
]])


-------------------------------------------------------------------------------
-- Key mappings
-------------------------------------------------------------------------------
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

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { buffer = 0 })
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>",
	{ buffer = 0 })
vim.keymap.set("n", "gT", "<cmd>lua vim.lsp.buf.type_definition()<cr>",
	{ buffer = 0 })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>",
	{ buffer = 0 })
vim.keymap.set("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>")
vim.keymap.set("n", "<leader>r", "<cmd>lua vim.lsp.buf.rename()<cr>")
vim.keymap.set("n", "<leader>A", "<cmd>lua vim.lsp.buf.code.acion()<cr>")


-------------------------------------------------------------------------------
-- Plugins
-------------------------------------------------------------------------------
local plugins = {
	-- Common
	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-cmdline",
	"hrsh7th/nvim-cmp",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
	"tpope/vim-commentary",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"vim-airline/vim-airline",
	"ctrlpvim/ctrlp.vim",
	"jiangmiao/auto-pairs",
	"nelstrom/vim-visual-star-search",
	"dhruvasagar/vim-table-mode",
	--:TSInstall c lua vim vimdoc markdown
	"nvim-treesitter/nvim-treesitter",
	"nvim-telescope/telescope.nvim",
	-- lua
	{
		"S1M0N38/love2d.nvim",
		cmd = "LoveRun",
		opts = {},
		keys = {
			{
				"<leader>v",
				desc = "LÖVE",
			},
			{
				"<f6>",
				"<cmd>w<cr><cmd>LoveRun<cr>",
				desc = "Run LÖVE",
			},
			{
				"<f7>",
				"<cmd>LoveStop<cr>",
				desc = "Stop LÖVE",
			},
		},
	},
	-- Go
	-- "fatih/vim-go",
	-- Web
	-- "mattn/emmet-vim",
	-- "vim-scripts/loremipsum",
}


-------------------------------------------------------------------------------
-- Emmet
-------------------------------------------------------------------------------
vim.g.user_emmet_leader_key = "<C-y>"
vim.g.user_emmet_install_global = 0


-------------------------------------------------------------------------------
-- Vim surround
-------------------------------------------------------------------------------
vim.g.surround_indent = 1


-------------------------------------------------------------------------------
-- Ctrl-P
-------------------------------------------------------------------------------
vim.g.wildignore = "*/node_modules/*,*.so,*.swp,*.zip,*.git,*.o,*.a,"


-------------------------------------------------------------------------------
-- netrw
-------------------------------------------------------------------------------
vim.g.netrw_banner = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 100
vim.g.netrw_altv = 1
vim.keymap.set({ "n", "i" }, "<c-g>", "<cmd>Vex<cr>")


-------------------------------------------------------------------------------
-- Setup Lazy
-------------------------------------------------------------------------------
require("lazy").setup(plugins, {
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "retrobox" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})


-------------------------------------------------------------------------------
-- LSP
-------------------------------------------------------------------------------
require("lspconfig").lua_ls.setup({
	on_attach = function()
		-- add code if needed
	end,
	on_init = function(_client)
		-- add code if needed
	end,
})


-------------------------------------------------------------------------------
-- cmp
-------------------------------------------------------------------------------
require("luasnip.loaders.from_snipmate").lazy_load()
vim.opt.completeopt = { "menu", "menuone", "noselect" }
local cmp = require("cmp")
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})


local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Add for each lsp server you've enabled.
require("lspconfig")["lua_ls"].setup {
	capabilities = capabilities,
}

-- To use git you need to install the plugin petertriho/cmp-git and
-- uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup()
--]]


-------------------------------------------------------------------------------
-- TODO
-------------------------------------------------------------------------------
-- TODO make function to swith to russian.
--set spelllang=ru_ru
--set keymap=russian-jcuken
