" leader key
let mapleader=','

" move the movement keys, with sensible move-up and move-down
noremap j h
noremap k gj
noremap l gk
noremap ; l

noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
noremap <C-w>; <C-w>l

" disable arrow movement
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" save with sudo
command! W w !sudo tee  > /dev/null

" plugin panes
map <F5> <Esc>:UndotreeToggle<CR>

" allow repeat from visual mode
vnoremap . <C-c>.

" more convenient page up
noremap <C-s> <C-u>

" toggle paste with F2 and with leader-p
set pastetoggle=<F2>
map <leader>p <F2>

" maximize the current split and make them equal easily
nnoremap <leader>o <c-w><Bar><c-w>_<cr>
nnoremap <leader>= <c-w>=

