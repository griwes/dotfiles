set laststatus=2

let g:airline_theme = 'griwes'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_powerline_fonts = 0

let g:airline_skip_empty_sections = 1

let g:airline#extensions#branch#enabled = 0

set fillchars=stl:-,stlnc:-,vert:\|
set noshowmode

" Turn the theme into a disabled one when losing focus, and turn it back when
" gaining it back.
autocmd FocusLost * call s:focus_lost()

let s:focus_setup_done = 0
function! s:focus_lost()
    AirlineTheme griwes_focus_lost
    if s:focus_setup_done == 0
        autocmd! FocusGained * AirlineTheme griwes
    endif
endfunction

