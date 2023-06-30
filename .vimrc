" Plugins {{{
set nocompatible

call plug#begin()

Plug 'sainnhe/everforest'
Plug 'sheerun/vim-polyglot'

call plug#end()
" }}}
    " Colors {{{
syntax enable		" enable syntax processing

set t_Co=256

" Important!!
if exists('+termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" For dark version.
set background=dark

" For light version.
"set background=light

" Set contrast.
" Available values: 'hard', 'medium'(default), 'soft'
let g:everforest_background = 'hard'

" For better performance
let g:everforest_better_performance = 1

" Patch comments looking off
let g:everforest_disable_italic_comment = 1

colorscheme everforest

" }}}
" Spaces and Tabs {{{
set tabstop=4		" number of spaces tab when opening file
set softtabstop=4	" number of spaces tab when editing file
set shiftwidth=4    " number of spaces on return (I think)
set expandtab		" tabs are spaces
filetype indent on	" load filetype-specific indent files
" (Shift)Tab (de)indents code
noremap <Tab> >
noremap <S-Tab> <
" }}}
" UI Config {{{
set number		    " show line number
set relativenumber  " relative line numbers"
set showcmd		    " show command in bottom bar
set wildmenu		" visual autocomplete for command menu
set showmatch		" highlight matching brackets
" }}}
" Searching {{{
set incsearch		    " search as characters are entered
set hlsearch		    " highlight matches
let mapleader=","	    " leader is comma
set path+=**

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" Folding {{{
set foldenable          " enable folding
set foldlevelstart=10   " open most folds by default
set foldnestmax=10      " 10 nested fold max

" space opens/closes folds
noremap <space> za     
" }}}
" Movement {{{
" move vertically by visual line
nnoremap j gj
nnoremap k gk

" move to beginning/end of line
" nnoremap E $
" nnoremap B ^

" restrict movement to learn new macros
" nnoremap $ <nop>
" nnoremap ^ <nop>

" restrict movement to learn hjkl
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" }}}
" Move Lines {{{
" move up
nnoremap ˚ :m .-2<CR>==
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ˚ :m '<-2<CR>gv=gv
" move down
nnoremap ∆ :m .+1<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
" }}}
" Undo {{{
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir
" }}}

set modelines=1
" vim:foldmethod=marker:foldlevel=0
