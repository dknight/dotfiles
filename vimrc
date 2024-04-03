" I try to keep it compatible with vim and neovim both.
"======================================================================
"======================== Global Variables ============================
"======================================================================
" let s:uname = system("uname -s")

" Fix scrolling issue in tmux or GNU screen.
if &term =~ '256color'
    set t_ut=y
endif

"======================================================================
"======================== Usability ===================================
"======================================================================
set nocompatible
set number

" Disable mouse for neovim
set mouse=

" utf-8 for files.
set fileencoding=utf-8

" Change cursors
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

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

" Allow hidden buffers.
set hidden

" Set language for spell check
set spelllang=en_us

" TODO make function to swith to russian.
" set spelllang=ru_ru
" set keymap=russian-jcuken

" TODO contribute estonian language (when free time or ask help)
" http://ftp.vim.org/vim/runtime/spell/README.txt

" Enable folding
set foldmethod=indent
set foldlevel=99

" Force Vim to use system clipboard
" set clipboard=unnamedplus

" Set my favourite dark scheme.
" "set termguicolors
colorscheme wasabi256
" colorscheme darkspace

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Smartindent, do not forgot this
set smartindent

" Rulers
set rulerformat=%l,%v

" Will work in old unix style with max line size of 79 chars
highlight ColorColumn ctermbg=234
let &colorcolumn="75,79"

" Show hidden symbols
set list

set listchars=tab:▸\ ,trail:.,extends:>,precedes:< ",eol:$

" Highlights
highlight NonText ctermfg=234
highlight SpecialKey ctermfg=234
highlight Todo ctermbg=None ctermfg=11 cterm=Bold

" Highlight cursor line
set cursorline
" highlight CursorLineNr ctermfg=4
highlight CursorLine ctermbg=233 ctermfg=none

" Searching
set ignorecase      " searches are case insensitive...
set infercase       " completion case
set smartcase       " unless they contain at least one capital letter

" Hightlight search colors
hi! Search cterm=none ctermbg=221
hi! TermCursorNC ctermfg=15 ctermbg=14 cterm=none

" save up to 100 marks, enable capital marks
set viminfo='100,f1

" screen will not be redrawn while running macros, registers or other
" non-typed commands.
set lazyredraw

" Flagging Unnecessary Whitespace
highlight BadWhitespace ctermbg=red

" Undo settings
set undofile
set undodir="~/.vim/undodir"

" Spilts diff screen VERTICALY, not horizontally!
set diffopt+=vertical

" Hard wrap (experimental for me).
set textwidth=78

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
iab <expr> dt! system("date +%Y-%m-%d")
iab <expr> dt8601! system("date --iso-8601=seconds")
iab <expr> dt3339! system("date --rfc-3339=seconds")

"======================================================================
"======================== Mappings ====================================
"======================================================================
" Disabled arrow to get us" Make work with Vim faster,
" use jk instead on <Esc>
imap jk <Esc>

map <leader>b :bd!<CR>

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

tnoremap <Esc> <C-\><C-n>

" Ctrl+S for save files
nnoremap <silent> <C-S> :<C-u>write<CR>

" Spell check
map <leader>s :set spell!<CR>

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
nnoremap <leader>j :m.+1<CR>
nnoremap <leader>k :m.-2<CR>

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
    " Preparation : save last search, and cursor position.
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

" Show traling spaces
match TrailingSpaces /\s\+$/
highlight TrailingSpaces ctermbg=red guibg=red

" From Practical Vim book
" cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

noremap <C-g> :Vex<CR>
noremap <C-g><C-x> :call <SID>close_explorer_buffers()<CR>

nnoremap <C-l> :set hlsearch!<CR>

"======================================================================
"========================== Plugins ===================================
"======================================================================
packloadall
packadd minpac
call minpac#init()

" Common
call minpac#add('tpope/vim-commentary')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-repeat')
" call minpac#add('tpope/vim-abolish')
call minpac#add('vim-airline/vim-airline')
call minpac#add('vim-airline/vim-airline-themes')
call minpac#add('ctrlpvim/ctrlp.vim')
call minpac#add('Yggdroot/indentLine')
call minpac#add('jiangmiao/auto-pairs')
call minpac#add('nelstrom/vim-visual-star-search')
call minpac#add('dhruvasagar/vim-table-mode')
call minpac#add('flazz/vim-colorschemes')

" Go
call minpac#add('fatih/vim-go')

" Web
call minpac#add('mattn/emmet-vim')
call minpac#add('vim-scripts/loremipsum')

" Cleans installed packages
command! PackUpdate call minpac#update()
command! PackClean call minpac#clean()

" indentLine {
    " let g:indentLine_color_term = 232
    let g:indentLine_char_list = ['|', '¦', '┆', '┊']
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

" neosnippets {
     " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    imap <C-k>     <Plug>(neosnippet_expand_or_jump)
    smap <C-k>     <Plug>(neosnippet_expand_or_jump)
    xmap <C-k>     <Plug>(neosnippet_expand_target)

    " SuperTab like snippets behavior.
    " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
    "imap <expr><TAB>
    " \ pumvisible() ? "\<C-n>" :
    " \ neosnippet#expandable_or_jumpable() ?
    " \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
    \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

    " For conceal markers.
    if has('conceal')
    set conceallevel=2 concealcursor=niv
    endif
"}

" airline {
    let g:airline_theme='serene'
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.colnr = ':'
    let g:airline_symbols.linenr = ' '
    let g:airline_symbols.maxlinenr = ''
"}

" go {
    au FileType go nmap <F4> :w<CR>:GoDef<CR>
    au FileType go nmap <F5> :w<CR>:GoRun ./...<CR>
    au FileType go nmap <F6> :w<CR>:GoBuild<CR>
    au FileType go nmap <F7> :w<CR>:GoTest<CR>
    au FileType go nmap <F8> :w<CR>:!go test -coverprofile c.out && go tool cover -html c.out<CR>
    au FileType go set tabstop=4
    au FileType go set shiftwidth=4
    au FileType go set softtabstop=4
    au FileType go set completeopt=longest,menuone
    let g:go_term_enabled=0
    let g:go_term_reuse=1
    let g:go_term_mode=":split eadirection"
    let g:go_term_close_on_exit = 0
    let g:go_term_height=40
    autocmd BufNewFile,BufRead *.gohtml set filetype=html
"}

" html {
    au FileType html set tabstop=2
    au FileType html set shiftwidth=2
    au FileType html set softtabstop=2
"}

" css {
    au FileType css set tabstop=2
    au FileType css set shiftwidth=2
    au FileType css set softtabstop=2
"}

" javascript {
    au FileType javascript set tabstop=2
    au FileType javascript set shiftwidth=2
    au FileType javascript set softtabstop=2
"}

" sh {
    au FileType sh nmap <F5> :w<CR>:!%%%<CR>
"}
" ============================== END ====================================

" Only project specific exec .vimrc from dir.
" It is better to set this option at the end of the file.
"set exrc " noexrc
set secure
