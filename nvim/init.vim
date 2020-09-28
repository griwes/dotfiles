" clear all predefined autocmds
autocmd!

" runtime paths
let vimrc_path = expand('<sfile>:p:h')
let rc_path = vimrc_path . '/rc'

" load configuration files
let rc_files = split(globpath(rc_path, '*.vim'), '\n')
for rc_file in rc_files
    exec 'source ' . rc_file
    unlet rc_file
endfor

" secure vimrc
set secure
