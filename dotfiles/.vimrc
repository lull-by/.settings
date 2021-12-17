" GENERAL SETTINGS
" ------------------------------------------------------------------------------
" Basic Settings

" vim-specific settings
set nocompatible " Don't be vi compatible
filetype indent plugin on "filetype indentation
set autoindent " Maintain indentation of prev line
syntax on " Turn on syntax highlighting
set backspace=indent,eol,start " backspace anything
set visualbell " Stop error beep
set ruler " show position in file
set laststatus=2 " have status bar on always
set notimeout ttimeout ttimeoutlen=200 " change command timeout

" General
set confirm " ask for confirmation for writing
if has('mouse')
  set mouse=a " enable mouse in all modes
endif
set guicursor= " Disable nvim gui cursor

" Columns
set colorcolumn=81
set nowrap

" Line Numbers
set number

" Backups
set noswapfile
set nobackup
set undodir=~/.vim/undo//
set undofile

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Folding
set foldmethod=syntax
set foldlevel=99

" Tab
set shiftwidth=2
set softtabstop=2
set expandtab

" REMAPS 
" ------------------------------------------------------------------------------
" Leader Keys
let mapleader = " "
let maplocalleader = ";"

" Redraw Screen - turns off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>

" tabs
nnoremap <leader>te :tabe<SPACE>
nnoremap <leader>th :tabp<CR>
nnoremap <leader>tl :tabn<CR>

" Toggle Wrap
nnoremap <leader>w :set wrap!<CR>

" Terminal Mode Exit
tnoremap <ESC> <C-\><C-n>

" PLUGINS
" ------------------------------------------------------------------------------
" Installs vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'junegunn/goyo.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'airblade/vim-gitgutter'
call plug#end()

" Goyo
" Writing Mode
nnoremap <leader>g :Goyo<CR>

" NERDTree
nnoremap <leader>f :NERDTreeToggle<CR>

" ALE
nnoremap <leader>a :ALEToggle<CR>

" vimtex
let g:tex_flavor = 'latex'

" Colorscheme
colorscheme dracula

" utilsnips
let g:UltiSnipsExpandTrigger="<c-x>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
