" Basic Settings
set nocompatible
filetype indent plugin on
syntax on
set wildmenu
set hidden
set showcmd
set hlsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set visualbell
set nostartofline
set ruler
set laststatus=2
set confirm
set mouse=a
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200

" Tab settings
set shiftwidth=2
set softtabstop=2
set expandtab

" Mappings 
let mapleader = ";"
let maplocalleader = ","
set pastetoggle=<F12> " Use <F11> to toggle between 'paste' and 'nopaste'

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" remap neovim terminal escape to escape
if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'ycm-core/YouCompleteMe'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale', { 'on': 'ALEToggle' }
Plug 'lervag/vimtex'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
call plug#end()

" NERDTree Config
nmap <C-f> :NERDTreeToggle <CR>
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

" ALE Config
nmap <C-a> :ALEToggle <CR>

"vimtex Config
let g:tex_flavor = 'latex'

"color config
colorscheme dracula
