" viminfo
set viminfo='10,\"100,:20,%,n~/.viminfo

" backup
" save either in local .vim-backup, in $VIM/backup, or in .
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=$BACKUP_PATH
set backupdir^=./.vim-backup/
set backup

" swap
" save either in local .vim-swap, in $VIM/swap, or in .
set directory=./.vim-swap//
set directory+=$SWAP_PATH//
set directory+=/tmp//
set directory+=.

" undo
" save either in local .vim-undo, in $VIM/undo, or in .
if exists("+undofile")
    set undodir=./.vim-undo//
    set undodir+=$UNDO_PATH//
    set undodir+=.

    set undolevels=1024
    set undofile
endif

" history
set history=1024

set hidden

