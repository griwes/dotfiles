" fzf

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

nmap <C-p> :FzfLua files<CR>
nmap <C-o> :FzfLua oldfiles<CR>
nmap <C-b> :FzfLua buffers<CR>

nmap <C-g>c :FzfLua git_commits<CR>
nmap <C-g>b :FzfLua git_branches<CR>

nmap <leader><leader>lr :FzfLua lsp_references<CR>
nmap <leader><leader>ld :FzfLua lsp_definitions<CR>
nmap <leader><leader>le :FzfLua lsp_document_diagnostics<CR>
nmap <leader><leader>la :CodeActionMenu<CR>

nmap <leader><leader>fb :FzfLua builtin<CR>

nmap <leader><leader>db :FzfLua dap_breakpoints<CR>
nmap <leader><leader>df :FzfLua dap_frames<CR>
nmap <leader><leader>dc :FzfLua dap_configurations<CR>

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
      \   ]
      \ }

let g:rainbow_conf = {
    \ 'guifgs': [
      \ 'dodgerblue',
      \ 'slategray',
      \ 'forestgreen',
      \ 'deepskyblue',
      \ 'tomato',
      \ 'slategray',
      \ 'forestgreen',
      \ 'springgreen4'
    \ ]
    \}

au Filetype * RainbowToggleOn
" the plugin breaks CMake highlighting, so disable it there
au Filetype cmake RainbowToggleOff

