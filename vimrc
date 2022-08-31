"======================================================================
"======================== Usability ===================================
"======================================================================
" Set line numbers
set number

" utf-8 for files.
set fileencoding=utf-8

" Disable error sounds and window flash
" set noerrorbells visualbell t_vb=
" set t_vb=
" set visualbell

" Detect file type
filetype on
filetype plugin on
filetype indent on
set omnifunc=syntaxcomplete#Complete

" Syntax hightlighting
syntax on

" Set language for spell check
set spelllang=en_us
"set spelllang=ru_ru

" Enable folding
set foldmethod=indent
set foldlevel=99

" Force Vim to use system clipboard
set clipboard=unnamedplus

" Set my favourite dark scheme, cannot live without it.
set termguicolors
set background=dark
colorscheme tokyonight
let g:tokyonight_style='night'
" colorscheme darkspace

" set tabstop=4
" set shiftwidth=4
" set softtabstop=4
" set noexpandtab
"
" Smartindent, do not forgot this
set smartindent

" Rulers
set rulerformat=%l,%v

" Will work in old unix style with max line size of 79 chars
highlight ColorColumn ctermbg=232 guibg=#262626
let &colorcolumn="75,79"

" Show hidden symbols
" set nolist

" set listchars=tab:▸\ ,eol:$,trail:.
set listchars=tab:▸\ ,trail:.

" Invisible character colors
highlight NonText guifg=#4a4a59 ctermfg=233
highlight SpecialKey guifg=#4a4a59 ctermfg=233
highlight Todo ctermfg=black ctermbg=yellow

" Searching
set ignorecase      " searches are case insensitive...
set infercase       " completion case
set smartcase       " unless they contain at least one capital letter

" Hightlight search colors
hi! Search cterm=NONE ctermbg=221
hi! TermCursorNC ctermfg=15 guifg=#fdf6e3 ctermbg=14 guibg=#93a1a1 cterm=NONE gui=NONE

" save up to 100 marks, enable capital marks
set viminfo='100,f1

" screen will not be redrawn while running macros, registers or other
" non-typed comments
set lazyredraw

" Flagging Unnecessary Whitespace
highlight BadWhitespace ctermbg=red guibg=darkred

" Undo settings
set undofile
set undodir="~/.vim/undodir"

" Spilts diff screen VERTICALY, not horizontally!
set diffopt+=vertical

" Matchit.vim
runtime macros/matchit.vim

"======================================================================
"======================== Commands ====================================
"======================================================================
" Share the code with https://sprunge.us
command! -nargs=0 -bar Share execute "!cat % | curl -F 'sprunge=<-' http://sprunge.us"

"======================================================================
"======================== Abbrevs =====================================
"======================================================================
iab <expr> dt! strftime("%Y-%m-%d")
iab <expr> dts! strftime("%Y-%m-%dT%H:%M:%S")

"======================================================================
"======================== Mappings ====================================
"======================================================================
" Disabled arrow to get us" Make work with Vim faster,
" use jk instead on <Esc>
imap jk <Esc>

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

" Clear search highlight
map <silent> <C-l> :noh<CR>

tnoremap <Esc> <C-\><C-n>

" Ctrl+S for save files
nnoremap <silent> <C-S> :<C-u>write<CR>

" Spell check
map <leader>s :set spell!<CR>

" Use spell check
nmap <silent> <leader>l :set spell!<CR>

" Edit .vimrc in new tab
nmap <leader>v :tabedit $VIM/vimrc<CR>

" Buffers navigation
nnoremap <silent> [b :bprev<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

" Count navigation (quickfix list)
nnoremap <silent> [c :cprev<CR>
nnoremap <silent> ]c :cnext<CR>
nnoremap <silent> [C :cfirst<CR>
nnoremap <silent> ]C :clast<CR>

" Move line up and down
nnoremap <C-S-j> :m .+1<CR>==
nnoremap <C-S-k> :m .-2<CR>==

" Repeat command with Q (resets default Ex-mode mode with Q)
nnoremap Q @='n.'<CR>

" Substitute :&&
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <Leader>; A;<ESC>
inoremap <Leader>; <ESC>A;

" Tabs navigation -----------------------------------------------------
nnoremap <silent> ]t :tabnext<CR>
nnoremap <silent> [t :tabprev<cr>
nnoremap <silent> [T :tabfirst<cr>
nnoremap <silent> ]T :tablast<CR>
" nnoremap <silent> <C-t> :tabnew<CR>

" Remove trailing Whitespaces
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nnoremap <silent> <leader><C-s><C-s> :call <SID>StripTrailingWhitespaces()<CR>

" Expands the path by %% expression
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" From Practical Vim book
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

noremap <C-g> :Vex<CR>
noremap <C-g><C-x> :call <SID>close_explorer_buffers()<CR>

"======================================================================
"========================== Plugins ===================================
"======================================================================
packloadall
packadd minpac
call minpac#init()

" Common
call minpac#add('tpope/vim-commentary')
" call minpac#add('SirVer/ultisnips')
call minpac#add('Shougo/neosnippet.vim')
call minpac#add('Shougo/neosnippet-snippets')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('tpope/vim-surround')
" call minpac#add('tpope/vim-abolish')
call minpac#add('vim-syntastic/syntastic')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('Yggdroot/indentLine')
call minpac#add('rstacruz/vim-closer')
" call minpac#add('tpope/vim-endwise')
" call minpac#add('jiangmiao/auto-pairs')
call minpac#add('nelstrom/vim-visual-star-search')
" call minpac#add('neoclide/coc.nvim')
call minpac#add('dhruvasagar/vim-table-mode')
call minpac#add('ervandew/supertab')

" Lua
" call minpac#add('tbastos/vim-lua')
" call minpac#add('xolox/vim-misc')
" call minpac#add('xolox/vim-lua-ftplugin')

" Go
call minpac#add('fatih/vim-go')

" Web
call minpac#add('mattn/emmet-vim')
call minpac#add('alvan/vim-closetag')
call minpac#add('vim-scripts/loremipsum')
call minpac#add('prettier/vim-prettier')

" Cleans installed packages
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

" Super Tab {
    let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"}

" Syntastic {
    set statusline+=%#warningmsg#
    set statusline+=%{SyntasticStatuslineFlag()}
    set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
"}

" IndentLine {
    " let g:indentLine_char_list = ['|', '¦', '┆', '┊']
    let g:indentLine_char_list = ['┊']
"}

" Emmet {
    let g:user_emmet_leader_key='<C-y>'
    let g:user_emmet_install_global = 0
    autocmd FileType html,css,markdown EmmetInstall
"}

" Surround {
    let g:surround_indent = 1
"}

" CtrlP {
    set wildignore+=*/node_modules/*,*.so,*.swp,*.zip,*.git
"}

" Lua {
    " let g:lua_syntax_someoption = 1
    " let g:lua_complete_omni = 1
"}

" netrw standard plugin {
    let g:netrw_banner = 1 " 0 for remove banner, I command toggles banner
    let g:netrw_liststyle = 3
    " 1 - open files in a new horizontal split
    " 2 - open files in a new vertical split
    " 3 - open files in a new tab
    " 4 - open in previous window
    let g:netrw_browse_split = 4
    let g:netrw_winsize = 100 " in percent
    let g:netrw_altv = 1
    function! s:close_explorer_buffers()
       for i in range(1, bufnr('$'))
           if getbufvar(i, '&filetype') == "netrw"
               silent exe 'bdelete! ' . i
           endif
       endfor
   endfunction
"}

" ctags {
    " autocmd BufWritePost * call system("ctags -R")
"}

" Table mode {
    function! s:isAtStartOfLine(mapping)
        let text_before_cursor = getline('.')[0 : col('.')-1]
        let mapping_pattern = '\V' . escape(a:mapping, '\')
        let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
        return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
    endfunction

    inoreabbrev <expr> <bar><bar>
      \ <SID>isAtStartOfLine('\|\|') ?
      \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
    inoreabbrev <expr> __
      \ <SID>isAtStartOfLine('__') ?
      \ '<c-o>:silent! TableModeDisable<cr>' : '__'

"}

" neosnippet {
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)
    " xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)

    " SuperTab like snippets behavior.
    " imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    "  \ "\<Plug>(neosnippet_expand_or_jump)"
    "  \: pumvisible() ? "\<C-n>" : "\<TAB>"
    " smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    "  \ "\<Plug>(neosnippet_expand_or_jump)"
    "  \: "\<TAB>"

    " For snippet_complete marker.
    if has('conceal')
      set conceallevel=2 concealcursor=i
    endif
"}

" airline {
   let g:airline_theme='serene'
   " if !exists('g:airline_symbols')
   "    let g:airline_symbols = {}
   " endif
   let g:airline_symbols.colnr = ':'
   let g:airline_symbols.linenr = ' '
   let g:airline_symbols.maxlinenr = ''
"}
" ============================== END ====================================

" Only project specific exec .vimrc from dir.
" It is better to set this option at the end of the file.
"set exrc " noexrc
set secure
