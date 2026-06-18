vim.cmd([[highlight! link Substitute CurSearch]])

if vim.g.neovide ~= nil then
    vim.cmd([[
        highlight! default FloatBorder blend=75
        highlight! default CursorLine blend=75
        highlight! default FloatTitle blend=75
        highlight! default Title blend=75
    ]])
else
    vim.cmd([[
        highlight! default FloatBorder blend=0
        highlight! default CursorLine blend=0
        highlight! default FloatTitle blend=0
        highlight! default Title blend=0
    ]])
end

vim.cmd([[
    highlight default link cStructure Keyword
    highlight default link cppStructure Keyword
    highlight default link cStorageClass Keyword
    highlight default link cppStorageClass Keyword

    highlight default link cStaticAssert Keyword
    highlight default link cppStaticAssert Keyword

    highlight default link cppOperator cLabel
]])
