" backup
let dir = stdpath('data') . '/backup'
silent execute '!mkdir -p ' . dir
exec 'set backupdir=' . dir
set backup
unlet dir

" swap
let dir = stdpath('data') . '/swap'
silent execute '!mkdir -p ' . dir
exec 'set directory=' . dir
unlet dir

" undo
let dir = stdpath('data') . '/undo'
silent execute '!mkdir -p ' . dir
exec 'set undodir=' . dir
unlet dir

set undolevels=1024
set undofile

" history
set history=1024

