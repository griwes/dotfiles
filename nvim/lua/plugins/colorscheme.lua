return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            options = {
                transparent = true,
                dim_inactive = false,
                styles = {
                    comments = 'italic',
                    keywords = 'bold',
                },
                modules = {
                    diagnostic = {
                        enable = true,
                        background = false,
                    },
                    native_lsp = {
                        enabled = true,
                        background = false,
                    },
                },
            },
            palettes = {
            },
            specs = {
                all = {
                    syntax = {
                        variable = 'magenta.bright',
                        builtin2 = '',
                    },
                },
            },
            groups = {
                all = {
                    NormalFloat = { bg = '' },
                    Folded = { fg = '', bg = '' },
                    Conceal = { link = 'Directory' },

                    CursorLine = { bg = 'None' },

                    LspInlayHint = { style = 'italic' },
                    LspReferenceText = { fg = '', bg = '', style = 'bold,underline' },
                    LspSignatureActiveParameter = { fg = '', style = 'bold,italic,underline', sp = 'palette.white' },

                    ['@namespace'] = { fg = 'palette.cyan.dim' },
                    ['@variable.parameter'] = { link = '@variable' },
                    ['@parameter'] = { link = '@variable' },

                    ['@keyword.return'] = { link = '@keyword' },
                    ['@keyword.operator'] = { link = '@keyword' },
                    ['@keyword.modifier'] = { link = '@keyword' },
                    ['@type.qualifier'] = { link = '@keyword' },
                    ['@exception'] = { link = '@keyword' },
                    ['@conditional'] = { link = '@keyword' },

                    ['@function.builtin'] = { fg = '' },
                    ['@constant.builtin'] = { link = '@constant' },
                    ['@function.method.call'] = { link = 'Function' },

                    -- treesitter, for some reason, throws these onto dependent function calls
                    -- but that's wrong, those should be highlighted as functions
                    ['@constructor.cpp'] = { link = 'Function' },
                    ['@constructor.cuda'] = { link = 'Function' },

                    ['@lsp.type.concept'] = { link = '@variable.builtin' },
                    ['@lsp.type.variable'] = { link = '@variable' },
                    ['@lsp.type.parameter'] = { link = '@variable' },

                    ['@lsp.mod.constructorOrDestructor'] = { link = '@constructor' },
                    ['@lsp.mod.dependentName'] = { style = 'italic' },

                    ['@lsp.typemod.type.defaultLibrary'] = { fg = '' },
                    ['@lsp.typemod.class.defaultLibrary'] = { fg = '' },
                    ['@lsp.typemod.variable.defaultLibrary'] = { fg = '' },
                    ['@lsp.typemod.enum.defaultLibrary'] = { fg = '' },
                    ['@lsp.typemod.enumMember.defaultLibrary'] = { fg = '' },
                    ['@lsp.typemod.typeParameter.readonly'] = { link = 'Constant' },
                    ['@lsp.typemod.variable.fileScope'] = { style = 'italic' },

                    DiffInline = { style = 'bold,italic,underdotted' },
                    GitSignsAddInline = { link = 'DiffInline' },
                    GitSignsAddLnInline = { link = 'DiffInline' },
                    GitSignsChangeInline = { link = 'DiffInline' },
                    GitSignsChangeLnInline = { link = 'DiffInline' },
                    GitSignsDeleteInline = { link = 'DiffInline' },
                    GitSignsDeleteLnInline = { link = 'DiffInline' },

                    DiffAdd = { fg = 'palette.green', style = '' },
                    DiffDelete = { fg = 'palette.red', style = '' },
                    DiffText = { fg = 'palette.yellow', bg = 'palette.bg2', style = 'bold,underdotted' },

                    NeogitHunkHeader = { bg = '' },
                    NeogitDiffContext = { link = 'Normal' },
                    NeogitChangeAdded = { link = 'NeoTreeGitAdded' },
                    NeogitChangeNewFile = { link = 'NeoTreeGitAdded' },
                    NeogitChangeModified = { link = 'NeoTreeGitModified' },
                    NeogitChangeDeleted = { link = 'NeoTreeGitDeleted' },
                    NeogitChangeRenamed = { link = 'NeoTreeGitRenamed' },
                    NeogitChangeBothModified = { link = 'NeoTreeGitConflict' },
                    NeogitChangeUpdated = { link = 'NeoTreeGitModified' },
                    NeogitChangeCopied = { link = 'NeoTreeGitAdded' },

                    WhichKeyFloat = { bg = '' },

                    NeoTreeFloatBorder = { link = 'DiagnosticInfo' },
                    NeoTreeFloatTitle = { link = 'DiagnosticInfo' },

                    BqfPreviewRange = { link = 'Visual' },
                    BqfPreviewCursor = { link = 'Visual' },

                    BlinkCmpMenu = { link = 'NormalFloat' },
                    BlinkCmpMenuBorder = { link = 'FloatBorder' },
                    BlinkCmpMenuSelection = { link = 'Visual' },
                    BlinkCmpDocBorder = { link = 'FloatBorder' },
                    BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
                    BlinkCmpGhostText = { link = 'Comment' },
                },
            },
        },
        config = function(_, opts)
            require('nightfox').setup(opts)

            vim.cmd('colorscheme nightfox')
        end,
    },
    {
        'nvim-tree/nvim-web-devicons',
    },
    {
        'rachartier/tiny-devicons-auto-colors.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons'
        },
        event = 'VeryLazy',
        config = function()
            require('tiny-devicons-auto-colors').setup(require('nightfox.palette').load('nightfox'))
        end
    }
}
