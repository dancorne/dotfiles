"obsolete now, as the presence of a ~/.vimrc implies this setting, but good to have anyway
set nocompatible

"Manage plugins with vim-plug
call plug#begin('~/.vim/plugged')

Plug 'chase/vim-ansible-yaml'
Plug 'mileszs/ack.vim'
Plug 'vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'

call plug#end()

syntax enable

"add line numbers
set number

"add textwidth
set formatoptions+=t
set tw=80

""search
set ignorecase
set smartcase
set hlsearch
set incsearch

"some latex-based settings
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
set iskeyword+=:

"theming
syntax on
set t_Co=256 "256 colours
set background=dark
colorscheme solarized
"set laststatus=2
"set lazyredraw

"CtrlP
"remap to use <c-p> below
"let g:ctrlp_map = '<Leader>o'

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
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

"frequently used
let mapleader = "\<Space>"
nmap <c-n> :bn<CR>
imap <c-n> <Esc>:bn<CR>
nmap <c-p> :bp<CR>
imap <c-p> <Esc>:bp<CR>
command! -range -nargs=0 -bar JsonTool <line1>,<line2>!python -m json.tool
nnoremap <Leader><Leader> :Ack!<space>

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

"clean up directories
set directory=~/.vim/swp
set backupdir=~/.vim/backup
