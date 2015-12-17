" Rainbow operators
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

au VimEnter * RainbowParentheses

