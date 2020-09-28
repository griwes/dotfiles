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
      \ ['blue',        'dodgerblue'],
      \ ['darkgray',    'slategray'],
      \ ['darkgreen',   'forestgreen'],
      \ ['darkcyan',    'deepskyblue'],
      \ ['darkmagenta', 'tomato'],
      \ ['blue',        'dodgerblue'],
      \ ['darkgray',    'slategray'],
      \ ['darkgreen',   'forestgreen'],
      \ ['darkcyan',    'springgreen4']
      \   ]
      \ }

au Filetype * RainbowParentheses
" the plugin breaks CMake highlighting, so disable it there
au Filetype cmake RainbowParentheses!

