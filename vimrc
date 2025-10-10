set nocompatible
set number
set hidden

syntax on
filetype plugin on
filetype plugin indent on
colorscheme darkblue

augroup omnifuncs
	autocmd!
	autocmd FileType * setlocal omnifunc=syntaxcomplete#Complete
augroup END

" Shortcuts
inoremap jk <esc>
noremap ]b :bprev<cr>
noremap [b :bnext<cr>
