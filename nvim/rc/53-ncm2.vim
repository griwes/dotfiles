autocmd BufEnter  *  call ncm2#enable_for_buffer()

set completeopt=noinsert,menuone,noselect

" use <TAB> to choose in the popup menu
imap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
