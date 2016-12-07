" leader key
let mapleader=','

" the most important lines ever
nnoremap ; :
vnoremap ; :

" sensible move-up and move-down
noremap j gj
noremap k gk

" save with sudo
command! W w !sudo tee  > /dev/null

" plugin panes
map <F5> <Esc>:UndotreeToggle<CR>
map <F8> <Esc>:TagbarToggle<CR>

" allow repeat from visual mode
vnoremap . <C-c>.

" use ctrl+s for saving in all modes
noremap <C-s> :write<CR>
vnoremap <C-s> <C-c>:write<CR>
inoremap <C-s> <C-o>:write<CR>

" toggle paste with F2 and with leader-p
set pastetoggle=<F2>
map <leader>p <F2>

" ClangFormat
noremap <C-k> :ClangFormat<CR>

