set nocompatible

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to 4 spaces.
set shiftwidth=4
" Set tab width to 4 columns.
set tabstop=4
" Use space characters instead of tabs.
set expandtab

" Add numbers to the file.
set number

" Set the commands to save in history default number is 20.
set history=1000
set undolevels=1000

" Do not save backup/swap files.
set nobackup
set noswapfile

" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" While searching though a file incrementally highlight matching characters as you type.
set incsearch
" Ignore capital letters during search.
set ignorecase
" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase
" Show matching words during a search.
set showmatch
" Use highlighting when doing a search.
set hlsearch

" Show partial command you type in the last line of the screen.
set showcmd
" Show the mode you are on the last line.
set showmode

" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest,full

" Enable mouse in all modes
set mouse=a

" Disable filetpye, this is important to do *before* plugins installation
filetype off

" --- PLUGINS
call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

call plug#end()

" Enable indentation, this is important to do *after* 'plug#end()'
filetype on
filetype plugin indent on

syntax on

" --- COLOR SCHEME
set bg=dark
color gruvbox
