" enable 256 colors
set t_Co=256

" but don't enable truecolor, because I haven't done proper tuning for
" termguicolors to look the way I want them to in the terminal, maybe one day
set notermguicolors

" set theme
colorscheme minimalist

" no background though, and make current line number actually visible
highlight LineNr ctermbg=None guibg=None
highlight CursorLineNr ctermfg=yellow ctermbg=None

highlight NonText ctermbg=None
highlight Normal ctermbg=None

highlight VertSplit ctermbg=none

" also, the theme is slightly too monotonic with its choice for Type
" so make it green-ish instead of purply
highlight Type ctermfg=114 guifg=#87d787

" make the macros stand out more than some of the keywords
highlight PreProc ctermfg=167 guifg=#d75f5f
" and make mor keywords used by Chromatica consistent
highlight Statement ctermfg=140 guifg=#af87d7

" make comments brighter in the presence of transparent background
highlight Comment ctermfg=247 guifg=#9e9e9e

" style tweaks for ncm2
highlight Pmenu ctermbg=black

" highlighted yank
highlight HighlightedyankRegion cterm=reverse gui=reverse

" traces
highlight link TracesSearch Cursor
highlight link TracesReplace DiffAdd

" make listchars visible
highlight NonText ctermfg=red guifg=red

" make errors actually readable
highlight Error cterm=italic ctermfg=red ctermbg=None guifg=red guibg=None
highlight ErrorMsg cterm=italic ctermfg=red ctermbg=None guifg=red guibg=None

