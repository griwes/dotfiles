" Ctrl-P
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.gz,*.jar,*.o,*.d,*.*~,*.a,*.class,*.otf,*.ttf,*.1,*.2,*.3,*.4,*.5,*.6,*.xc*
set wildignore+=cmake/**,CMakeFiles/**,*.includecache

" don't change cwd while I move around
let g:ctrlp_working_path_mode = 'r'

" add tags to the default set of searchers
let g:ctrlp_extensions = [ 'tag' ]

" use ctrlp-py-matcher
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

