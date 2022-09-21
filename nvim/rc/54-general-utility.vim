" fzf

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

nmap <C-p> :Files<CR>
nmap <C-o> :Tags<CR>

" rainbow parentheses
"
let g:rainbow#max_level = 32
let g:rainbow#pairs =
      \ [
      \   ['(', ')'],
      \   ['{', '}'],
      \   ['[', ']']
      \ ]
let g:rainbow#colors = {
      \   'dark': [
      \   ]
      \ }

let g:rainbow_conf = {
    \ 'guifgs': [
      \ 'dodgerblue',
      \ 'slategray',
      \ 'forestgreen',
      \ 'deepskyblue',
      \ 'tomato',
      \ 'slategray',
      \ 'forestgreen',
      \ 'springgreen4'
    \ ]
    \}

au Filetype * RainbowToggleOn
" the plugin breaks CMake highlighting, so disable it there
au Filetype cmake RainbowToggleOff

