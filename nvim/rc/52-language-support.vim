" language client

" required for operations modifying multiple buffers like rename
set hidden

let g:LanguageClient_serverCommands = {
    \ 'cpp': ['clangd', '--header-insertion=never', '--clang-tidy'],
    \ 'python': ['~/.local/bin/pyls'],
    \ 'rust': ['~/.cargo/bin/rls']
    \ }

" to debug clangd, use the line below instead of the actual cpp config:
"    \ 'cpp': ['bash', '-c', 'clangd -log=verbose 2>~/clangd-log'],

" remember to -xc++ in compile_flags.txt for C++ .h headers to work, eh

" chromatica.nvim configuration

let g:chromatica#libclang_path = '/usr/lib/llvm-10/lib/libclang.so.1'
let g:chromatica#responsive_mode = 1
let g:chromatica#enable_at_startup = 1

" auto-format C++
" don't format Vapor files
" don't format files with no filetype, because that blocks the LC forever
" should probably invest in its own filetype one day
autocmd BufRead * if empty(matchstr(@%, '*.vpr')) && !empty(&filetype) && !exists('b:formatting_autocmd_set')
    \ | execute 'autocmd BufWritePre <buffer> if LanguageClient_runSync("LanguageClient#isAlive")
        \ | call LanguageClient#textDocument_formatting_sync()
        \ | endif'
    \ | let b:formatting_autocmd_set = 1
    \ | endif
