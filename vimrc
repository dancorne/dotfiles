"obsolete now, as the presence of a ~/.vimrc implies this setting, but good to have anyway
set nocompatible

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
"status line
Bundle 'bling/vim-airline'
Bundle 'Lokaltog/powerline-fonts'
"syntax checking
Bundle 'scrooloose/syntastic'
"fuzzy search
Bundle 'kien/ctrlp.vim'
"python error checking
Bundle 'kevinw/pyflakes-vim'
"folding
Bundle 'Crapworks/python_fn.vim'
"wiki
Bundle 'vimwiki/vimwiki'

"themes
let base16colorspace=256  " Access colours present in 256 colorspace
Bundle 'moria'
Bundle 'chriskempson/base16-vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Slava/vim-colors-tomorrow'
Bundle 'junegunn/seoul256.vim'
syntax on
set t_Co=256 "256 colours
set background=dark
"colorscheme moria
set laststatus=2
"set lazyredraw

"airline settings
"let g:airline_theme             = 'solarized'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
let g:airline_powerline_fonts = 1 
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:gitgutter_fix_bg = 1
"let g:airline#extensions#tabline#left_sep = ' '
"let g:airline#extensions#tabline#left_alt_sep = '|'

"CtrlP
"remap to use <c-p> below
let g:ctrlp_map = '<Leader>o'

"add line numbering
set number
"set relativenumber

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
nnoremap <Leader>w :w<CR>
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a
nmap <c-n> :bn<CR>
imap <c-n> <Esc>:bn<CR>
nmap <c-p> :bp<CR>
imap <c-p> <Esc>:bp<CR>
nmap <c-w> :bd<CR>
imap <c-w> <Esc>:bd<CR>
command! -range -nargs=0 -bar JsonTool <line1>,<line2>!python -m json.tool

"git mappings
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gc :Gcommit -v -q <CR>
nnoremap <Leader>gd :Gitdiff<CR>
nnoremap <Leader>go :Git checkout <Space>
nnoremap <Leader>gb :Git branch <Space>
nnoremap <Leader>gg :Ggrep <Space>

"copy and paste to system clipboard
set clipboard=unnamed
"vmap <Leader>y "+y
"vmap <Leader>d "+d
"nmap <Leader>p "+p
"nmap <Leader>P "+P
"vmap <Leader>p "+p
"vmap <Leader>P "+P

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
