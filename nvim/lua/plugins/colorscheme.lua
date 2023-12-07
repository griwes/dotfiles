return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            require('nightfox').setup({
                options = {
                    transparent = true,
                    styles = {
                        comments = 'italic',
                    }
                },
                specs = {
                    all = {
                        syntax = {
                            keyword = '#9d79d6',
                            conditional = '#9d79d6',
                            variable = 'magenta.bright',
                        }
                    }
                },
            })

            vim.cmd [[
                colorscheme nightfox

                highlight VertSplit guifg=#505050
                highlight NormalFloat guibg=None

                highlight default link @lsp.type.namespace @namespace
                highlight default link @lsp.type.variable @variable
                highlight default link @lsp.type.property @property
                highlight! default link @lsp.type.parameter @variable
                highlight! default link @lsp.typemod.typeParameter.readonly @constant
                highlight default @lsp.type.concept guifg=LightGreen gui=italic
                highlight! default link @keyword.return @keyword
                highlight! default link @keyword.operator @keyword
                highlight! default link @exception @keyword
                highlight! default link @type.qualifier @keyword
                highlight! default link @lsp.mod.constructorOrDestructor @constructor

                highlight default @lsp.typemod.variable.fileScope gui=italic
                highlight default @lsp.mod.dependentName guifg=#81b29a gui=italic

                highlight clear @lsp.typemod.function.defaultLibrary
                highlight clear @lsp.typemod.method.defaultLibrary
                highlight clear @lsp.typemod.variable.defaultLibrary
                highlight clear @function.builtin
                highlight clear @variable.builtin
                highlight clear @type.builtin
                highlight clear @error

                highlight clear WhichKeyFloat

                highlight! default link cppCast Function
                highlight! default link cppOperator Function

                highlight HighlightedyankRegion cterm=reverse gui=reverse

                highlight! link LspInlayHint Comment
                highlight! link Folded Comment
                highlight! link BiscuitColor Comment

                highlight link TelescopePromptTitle lualine_transitional_lualine_a_insert_to_lualine_c_insert
                highlight link TelescopePromptBorder lualine_transitional_lualine_a_insert_to_lualine_c_insert
                highlight link TelescopeResultsTitle lualine_transitional_lualine_a_terminal_to_lualine_c_terminal
                highlight link TelescopeResultsBorder lualine_transitional_lualine_a_terminal_to_lualine_c_terminal
                highlight link TelescopePreviewTitle lualine_transitional_lualine_a_normal_to_lualine_c_normal
                highlight link TelescopePreviewBorder lualine_transitional_lualine_a_normal_to_lualine_c_normal

                highlight! link DiffAdd diffAdded
                highlight! link DiffDelete diffRemoved
                highlight! link DiffChange diffChanged

                highlight DiffInline gui=italic,bold blend=30
                highlight! default link GitSignsAddInline DiffInline
                highlight! default link GitSignsAddLnInline DiffInline
                highlight! default link GitSignsChangeInline DiffInline
                highlight! default link GitSignsChangeLnInline DiffInline
                highlight! default GitSignsDeleteInline gui=italic,bold,strikethrough
                highlight! default link GitSignsDeleteLnInline DiffInline

                highlight Special gui=nocombine
            ]]
        end,
    },
    {
        'nvim-tree/nvim-web-devicons',
        lazy = false,
    },
}
