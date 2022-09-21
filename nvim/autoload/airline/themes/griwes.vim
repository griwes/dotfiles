" Modified from night_owl vim-airline theme.
"
" Original credits:
" Port/inspired from https://github.com/sdras/night-owl-vscode-theme
" Jared Ramirez

let s:gui_black = "#282C34"
let s:cterm_black = 16

let s:gui_purple = "#C792EA"
let s:cterm_purple = 176
let s:gui_purple_offset = "#9f74bb"
let s:cterm_purple_offset = 139

let s:gui_yellow = "#FFD787"
let s:cterm_yellow = 222
let s:gui_yellow_offset = "#ccac6c"
let s:cterm_yellow_offset = 179

let s:gui_blue = "#81AAFF"
let s:cterm_blue = 111
let s:gui_blue_offset = "#6788cc"
let s:cterm_blue_offset = 68

let s:gui_cyan = "#83DCC8"
let s:cterm_cyan = 116
let s:gui_cyan_offset = "#68b0a0"
let s:cterm_cyan_offset = 73

let s:gui_green = "#AFD75F"
let s:cterm_green = 149
let s:gui_green_offset = "#8cac4c"
let s:cterm_green_offset = 107

let s:gui_white = "#FFFFFF"
let s:cterm_white = 255

let s:gui_dark_gray = "#606060"
let s:cterm_dark_gray = 'darkgray'

let g:airline#themes#griwes#palette = {}

let s:N1 = [ s:gui_black, s:gui_cyan, s:cterm_black, s:cterm_cyan ]
let s:N2 = [ s:gui_black, s:gui_cyan_offset,  s:cterm_black, s:cterm_cyan_offset ]
let s:N3 = [ s:gui_cyan, 'None', s:cterm_cyan, 'None' ]
let s:N3mod = [ s:gui_purple, 'None', s:cterm_purple, 'None' ]
let g:airline#themes#griwes#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#griwes#palette.normal_modified = airline#themes#generate_color_map(s:N1, s:N2, s:N3mod)

let s:I1 = [ s:gui_black, s:gui_green, s:cterm_black, s:cterm_green ]
let s:I2 = [ s:gui_black, s:gui_green_offset, s:cterm_black, s:cterm_green_offset ]
let s:I3 = [ s:gui_green, 'None', s:cterm_green, 'None' ]
let s:I3mod = [ s:gui_purple, 'None', s:cterm_purple, 'None' ]
let g:airline#themes#griwes#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#griwes#palette.insert_modified = airline#themes#generate_color_map(s:I1, s:I2, s:I3mod)

let s:V1 = [ s:gui_black, s:gui_blue, s:cterm_black, s:cterm_blue ]
let s:V2 = [ s:gui_black, s:gui_blue_offset,  s:cterm_black, s:cterm_blue_offset ]
let s:V3 = [ s:gui_blue, 'None', s:cterm_blue, 'None' ]
let s:V3mod = [ s:gui_purple, 'None', s:cterm_purple, 'None' ]
let g:airline#themes#griwes#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#griwes#palette.visual_modified = airline#themes#generate_color_map(s:V1, s:V2, s:V3mod)

let s:R1 = [ s:gui_black, s:gui_yellow, s:cterm_black, s:cterm_yellow ]
let s:R2 = [ s:gui_black, s:gui_yellow_offset, s:cterm_black, s:cterm_yellow_offset ]
let s:R3 = [ s:gui_yellow, 'None', s:cterm_yellow, 'None' ]
let s:R3mod = [ s:gui_purple, 'None', s:cterm_purple, 'None' ]
let g:airline#themes#griwes#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#griwes#palette.replace_modified = airline#themes#generate_color_map(s:R1, s:R2, s:R3mod)

let s:IA1 = [ s:gui_black, s:gui_dark_gray, s:cterm_black, s:cterm_dark_gray ]
let s:IA2 = [ s:gui_dark_gray, 'None', s:cterm_dark_gray, 'None' ]
let s:IA3 = [ s:gui_dark_gray, 'None', s:cterm_dark_gray, 'None' ]
let s:IA3mod = [ s:gui_purple, 'None', s:cterm_purple, 'None' ]
let g:airline#themes#griwes#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#griwes#palette.inactive_modified = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3mod)

