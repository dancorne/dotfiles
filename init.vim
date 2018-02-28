
"PLUGINS
call plug#begin('~/.config/nvim/plugged')
"Vim+tmux navigation
Plug 'christoomey/vim-tmux-navigator'
"Ansible filetype
Plug 'chase/vim-ansible-yaml'
"Plug 'MicahElliott/Rocannon' "Doesn't look nice with gruvbox :(
"Git tools
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
"Themes
Plug 'altercation/vim-colors-solarized'
Plug 'jpo/vim-railscasts-theme'
Plug 'KKPMW/moonshine-vim'
Plug 'morhetz/gruvbox'
Plug 'AlessandroYorba/Despacio'
"Running Make stuff
Plug 'benekastah/neomake'
"SimplenoteList etc
Plug 'mrtazz/simplenote.vim'
":SQLUFormatter to format SQL
Plug 'vim-scripts/SQLUtilities'
Plug 'vim-scripts/Align'
":DirDiff for directory diffing
Plug 'will133/vim-dirdiff'
"Browsing with -
Plug 'tpope/vim-vinegar'
"Shortcuts like ]q
Plug 'tpope/vim-unimpaired'
"FZF searching
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
"Browse history with :UndotreeToggle
Plug 'mbbill/undotree'
"ysaW etc. for surrounding
Plug 'tpope/vim-surround'
"Task and wiki
Plug 'vimwiki/vimwiki'
Plug 'tbabej/taskwiki'
Plug 'blindFS/vim-taskwarrior'
"Org-mode
"Plug 'dhruvasagar/vim-dotoo'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
call plug#end()

""BEHAVIOUR
syntax enable
set number
set hidden
let mapleader = "\<Space>"

filetype indent plugin on
set backspace=indent,eol,start
set modeline
set tabstop=8
set shiftwidth=4
set softtabstop=4

set mouse=r

set directory=~/.vim/swp
set backupdir=~/.vim/backup

nmap <c-n> :bn<CR>
imap <c-n> <Esc>:bn<CR>
"vmap <c-n> <Esc>:bn<CR>
"tmap <c-n> <c-\><c-n>:bn<CR>
nmap <c-p> :bp<CR>
imap <c-p> <Esc>:bp<CR>
"vmap <c-p> <Esc>:bp<CR>
"tmap <c-p> <c-\><c-n>:bp<CR>
autocmd! BufWritePost,BufEnter * Neomake


""TOOLS
command! -range -nargs=0 -bar JsonTool <line1>,<line2>!python -m json.tool

fun! RangerChooser()
  exec "silent !ranger --choosefile=/tmp/chosenfile " .           expand("%:p:h")
  if filereadable('/tmp/chosenfile')
    exec 'edit ' . system('cat /tmp/chosenfile')
    call system('rm /tmp/chosenfile')
  endif
  redraw!
endfun
map <Leader>x :call RangerChooser()<CR>

""VINEGAR
"nmap - <Plug>VinegarVerticalSplitUp
nmap - :Lexplore<CR>
let g:netrw_preview = 1
let g:netrw_winsize = 15

"in case sudo is forgotten
cmap w!! %!sudo tee > /dev/null %


""GIT
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>ga :Git add %:p<CR><CR>
nnoremap <Leader>gc :Gcommit -v -q <CR>
nnoremap <Leader>gd :Gitdiff<CR>
nnoremap <Leader>go :Git checkout <Space>
nnoremap <Leader>gb :Git branch <Space>
nnoremap <Leader>gg :Ggrep <Space>


""SIMPLENOTE
let g:SimplenoteUsername = ""
let g:SimplenotePassword = ""
let g:SimplenoteVertical = 1


""WIKI
let g:vimwiki_list = [{'path': '~/vimwiki/', 'auto_tags': 1}]
map <F5> o<CR><ESC>:put =strftime('%c')<CR>==o
autocmd BufWritePost,BufEnter *.wiki TaskWikiBufferLoad
let g:taskwiki_sort_order="urgency+"
let g:taskwiki_sort_orders={"U": "urgency-","T": "project+,due-"}

let g:org_agenda_files = ['~/org/*.org']

let g:dotoo#agenda#files = ['~/org/*.org']
let g:dotoo#capture#refile = ['~/refile.org']

""SEARCH
set ignorecase
set smartcase
set hlsearch
set incsearch
set wildmenu
set wildmode=longest,list,full

nnoremap <Leader><Leader> :Ag<CR>
nnoremap <Leader>f :FZF<CR>
nnoremap <Leader>c :Commits<CR>
nnoremap <Leader>h :History:<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>t :Tags<CR>
"let g:fzf_commits_log_options = 'log1'
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

"Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
if executable('rg')
    set grepprg=rg\ --vimgrep
    set grepformat=%f:%l:%c:%m
elseif executable('ag')
    set grepprg=ag\ --vimgrep
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('ack')
    set grepprg=ack\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif


""THEME
syntax on
set t_Co=256 "256 colours
set background=dark
colorscheme gruvbox
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]


""PYTHON
let g:neomake_python_enabled_makers = ['flake8', 'pep8']
" E501 is line length of 80 characters
let g:neomake_python_flake8_maker = { 'args': ['--ignore=E501'], }
let g:neomake_python_pep8_maker = { 'args': ['--max-line-length=200'], }


""LATEX
let g:tex_flavor='latex'
let g:Tex_DefaultTargetFormat = 'pdf'
let g:Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
set iskeyword+=:


""ANSIBLE
autocmd BufRead,BufNewFile *.yml setlocal filetype=ansible
