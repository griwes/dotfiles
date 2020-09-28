" enable syntax
syntax on

" shell
set shell=/bin/bash

" set proper numbering
set number
set relativenumber

" always show the sign column; makes for less confusing horizontal splits with
" my transparent status bar background

set signcolumn=yes

" make /g the default for :s
set gdefault

" make long lines wrap around
set wrap

" setup search options
set showmatch
set nohlsearch
set incsearch

set ignorecase
set smartcase

" \v by default
nnoremap / /\v
vnoremap / /\v

" indentation
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set scrolloff=4

set autoindent
set smartindent
set backspace=indent,eol,start

" show current mode
set showmode

" enable mouse
set mouse=a

" disable arrow movement
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" easier window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" allow local vimrc
set exrc

" remember cursor position
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" search for tags file up to /
set tags=tags;/

