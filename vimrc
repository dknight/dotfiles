set nocompatible
filetype plugin on
filetype plugin indent on
syntax on
set omnifunc=syntaxcomplete#Complete
colorscheme darkblue
set number
augroup omnifuncs
	autocmd!
	autocmd FileType * setlocal omnifunc=syntaxcomplete#Complete
augroup END
