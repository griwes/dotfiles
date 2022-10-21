set cursorline

" set theme
colorscheme minimalist

" no background though, and make current line number actually visible
highlight LineNr ctermbg=None guibg=None
highlight CursorLine ctermbg=None guibg=None
highlight CursorLineNr ctermfg=yellow ctermbg=None guifg=yellow guibg=None

highlight NonText ctermbg=None guibg=None
highlight Normal ctermbg=None guibg=None

highlight VertSplit ctermbg=none guibg=None

" brighter cursorline
highlight Cursor guifg=#a0a0a0

" also, the theme is slightly too monotonic with its choice for Type
" so make it green-ish instead of purply
highlight Type ctermfg=114 guifg=#87d787

" make the macros stand out more than some of the keywords
highlight PreProc ctermfg=167 guifg=#d75f5f
" and make mor keywords used by Chromatica consistent
highlight Statement ctermfg=140 guifg=#af87d7

" make comments brighter in the presence of transparent background
highlight Comment ctermfg=247 guifg=#9e9e9e gui=italic

" style tweaks for ncm2
highlight Pmenu ctermbg=black guibg=black

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

" force sane gitgutter style
highlight clear SignColumn
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

" visible hop colors
highlight HopNextKey1 cterm=bold ctermfg=166 gui=bold guifg=#d75f00
highlight HopNextKey2 ctermfg=172 guifg=#d78700

" indent line
highlight IndentBlanklineChar ctermfg=239 guifg=#4e4e4e

" vim-illuminate
highlight default IlluminatedWordText guibg=#303060 gui=bold
highlight default IlluminatedWordRead guibg=#303060 gui=bold
highlight default IlluminatedWordWrite guibg=#303060 gui=bold

" floats
highlight Pmenu guibg=None
highlight FloatBorder guifg=Gray guibg=None
highlight FzfLuaBorder guifg=Gray guibg=None

let g:code_action_menu_window_border = 'rounded'
