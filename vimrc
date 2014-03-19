"still no idea what this does, but its apparently good for many reasons
set nocompatible

"theme
syntax on
set background=dark

"add line numbering
set number

"vundle
filetype off "switch filetype off before loading vundle, switching on later
set rtp+=~/.vim/bundle/vundle/ "add vundle to the vim runtime
call vundle#rc() "start vundle
Bundle 'gmarik/vundle'

"
filetype indent plugin on
set backspace=indent,eol,start
set modeline
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4

"search settings
set ignorecase
set smartcase
set hlsearch
set incsearch

"in case sudo is forgotten
cmap w!! %!sudo tee > /dev/null %
