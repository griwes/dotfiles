vim.cmd [[
    highlight IndentBlanklineIndent guifg=#404040 gui=nocombine
    highlight HighlightedyankRegion cterm=reverse gui=reverse
]]

require('indent_blankline').setup({
    char_highlight_list = {
        'IndentBlanklineIndent',
    },
})
