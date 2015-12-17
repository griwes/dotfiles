let g:ycm_confirm_extra_conf = 0
let g:ycm_complete_in_comments = 1
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = ']]'
let g:ycm_enable_diagnostic_signs = 1

nnoremap <leader>g :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>G :YcmCompleter GoToDefinition<CR>

set omnifunc=syntaxcomplete#Complete
let g:ycm_key_invoke_completion = '<C-Space>'

" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,preview
"
" ^space for completion
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

" enter in the quickfix window doesn't focus the new buffer
au BufReadPost quickfix noremap <C-cr> <cr><c-w>p

