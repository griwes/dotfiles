" automatically write on buffer change
au FocusLost * :wa
set autowrite

" no error bells
set noerrorbells
set visualbell t_vb=

" makefiles need tabs
autocmd FileType make set noexpandtab tabstop=8 shiftwidth=8 softtabstop=0
" nasm in assembly
autocmd FileType asm set syntax=nasm

" highlight whitespace
set list
set listchars=tab:»·,trail:·,extends:#,nbsp:·

" make trailing whitespace red
highlight ExtraWhitespace ctermfg=red guifg=red
match ExtraWhitespace /\s\+$/

" and also delete them on write
autocmd BufWritePre * %s/\s\+$//e

" somehow indentlines tends to sometimes break...
autocmd VimEnter * nested :IndentLinesReset

" shell-like tab completion of commands
set wildmenu
set wildmode=list:longest

