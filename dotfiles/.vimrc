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
set confirm " ask for comfirmation for writing
set mouse=a " enable mouse in all modes
set guicursor= " Disable nvim gui cursor

" Columns
set colorcolumn=81
highlight ColorColumn ctermbg=8
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
let maplocalleader = "\\"

" Redraw Screen - turns off search highlighting until the next search
nnoremap <C-L> :nohl<CR><C-L>

" tabs
nnoremap <leader>te :tabe<SPACE>
nnoremap <leader>th :tabp<CR>
nnoremap <leader>tl :tabn<CR>

" PLUGINS
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'ycm-core/YouCompleteMe'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'dense-analysis/ale', { 'on': 'ALEToggle' }
  Plug 'lervag/vimtex'
  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'junegunn/goyo.vim'
call plug#end()

" PLUGIN-SPECIFIC
" ------------------------------------------------------------------------------

" Goyo
" Writing Mode
nnoremap <C-g> :Goyo<CR>:set wrap<CR>:hi Normal guibg=NONE ctermbg=NONE<CR>

" NERDTree
nmap <C-s> :NERDTreeToggle<CR>

" ALE
nmap <C-a> :ALEToggle<CR>

" vimtex
let g:tex_flavor = 'latex'

" Colorscheme
colorscheme dracula
hi Normal guibg=NONE ctermbg=NONE " Enable transparent background
