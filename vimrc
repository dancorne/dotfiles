"still no idea exactly what this does, but it revokes compatibility with vi and therefore enables a lot of vim features. Further research suggests the presence of a .vimrc disables compatability anyway.
set nocompatible

"theme
syntax on
set background=dark

"add line numbering
"set number
set relativenumber

"vundle
filetype off "switch filetype off before loading vundle, switching on later
set rtp+=~/.vim/bundle/vundle/ "add vundle to the vim runtime
call vundle#rc() "start vundle
Bundle 'gmarik/vundle'
"filesystem browsing
Bundle 'scrooloose/nerdtree'
"autocompletion features
Bundle 'ervandew/supertab'
"visual mode simplification
Bundle 'terryma/vim-expand-region'
"git integration
Bundle 'tpope/vim-fugitive'
"see git diff on the left
Bundle 'vim-gitgutter'
"see buffers in status bar
Bundle 'bling/vim-bufferline'
"
Bundle 'bling/vim-airline'
"syntax checking
Bundle 'scrooloose/syntastic'

"
filetype indent plugin on
set backspace=indent,eol,start
set modeline
set tabstop=8
set expandtab
set shiftwidth=4
set softtabstop=4
set undofile

"frequently used
let mapleader = "\<Space>"
nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>g :Gstatus<CR>

"copy and paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

"visual selections
nmap <Leader><Leader> V
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"search 
set ignorecase
set smartcase
"set hlsearch
set incsearch

"in case sudo is forgotten
cmap w!! %!sudo tee > /dev/null %

"predictions
set wildmenu
set wildmode=longest,list,full

"editing multiple files
set hidden "allow hiding unsaved files, rather than closing them
