local neovide_float_bg = vim.g.neovide and '#080808' or ''
local neovide_groups = {
    NormalFloat = { bg = '' },
    FloatBorder = { fg = 'fg3', bg = '' },
}

if vim.g.neovide then
    neovide_groups = {
        -- Neovide applies `g:neovide_normal_opacity` to the Normal background
        -- color. Use black here so editor transparency darkens the desktop
        -- instead of tinting it with Nightfox's blue background, matching
        -- Kitty's background.
        Normal = { bg = '#000000' },
        NormalNC = { bg = '#000000' },
        WinBar = { bg = '#000000' },
        WinBarNC = { bg = '#000000' },

        -- Neovide currently renders bg-less floating grids as a dark slab even
        -- when 'winblend' is 100. Giving float highlights a near-black real
        -- background lets the blend path make them visually transparent without
        -- tinting them like the Nightfox background would.
        NormalFloat = { bg = neovide_float_bg },
        FloatBorder = { fg = 'fg3', bg = neovide_float_bg },
        FloatTitle = { bg = neovide_float_bg },
        FloatFooter = { bg = neovide_float_bg },
        SnacksTitle = { bg = neovide_float_bg },
        SnacksFooter = { bg = neovide_float_bg },

        SnacksPicker = { bg = neovide_float_bg },
        SnacksPickerBorder = { link = 'FloatBorder' },
        SnacksPickerTitle = { bg = neovide_float_bg },
        SnacksPickerFooter = { bg = neovide_float_bg },
        SnacksPickerBox = { bg = neovide_float_bg },
        SnacksPickerBoxBorder = { link = 'FloatBorder' },
        SnacksPickerBoxTitle = { bg = neovide_float_bg },
        SnacksPickerBoxFooter = { bg = neovide_float_bg },
        SnacksPickerInput = { bg = neovide_float_bg },
        SnacksPickerInputTitle = { bg = neovide_float_bg },
        SnacksPickerInputBorder = { link = 'FloatBorder' },
        SnacksPickerInputFooter = { bg = neovide_float_bg },
        SnacksPickerList = { bg = neovide_float_bg },
        SnacksPickerListBorder = { link = 'FloatBorder' },
        SnacksPickerListTitle = { bg = neovide_float_bg },
        SnacksPickerListFooter = { bg = neovide_float_bg },
        SnacksPickerPreview = { bg = neovide_float_bg },
        SnacksPickerPreviewBorder = { link = 'FloatBorder' },
        SnacksPickerPreviewTitle = { bg = neovide_float_bg },
        SnacksPickerPreviewFooter = { bg = neovide_float_bg },

        SnacksInputTitle = { bg = neovide_float_bg },
        SnacksInputBorder = { link = 'FloatBorder' },

        WhichKeyBorder = { link = 'FloatBorder' },
        LazyBorder = { link = 'FloatBorder' },
        MasonBorder = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorder = { link = 'FloatBorder' },
        NoiceCmdlinePopupBorderSearch = { link = 'FloatBorder' },
        NoiceConfirmBorder = { link = 'FloatBorder' },
        NoicePopupBorder = { link = 'FloatBorder' },
        NoicePopupmenuBorder = { link = 'FloatBorder' },
        NoiceSplitBorder = { link = 'FloatBorder' },
    }
end

return {
    {
        'EdenEast/nightfox.nvim',
        lazy = false,
        priority = 1000,
        opts = {
            options = {
                -- Neovide's targeted background opacity only applies when
                -- Normal has an actual background color. TUI/terminal keeps
                -- the transparent theme; Neovide gets an alpha-blended Normal
                -- background via `g:neovide_normal_opacity`.
                transparent = not vim.g.neovide,
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
            palettes = {},
            specs = {
                all = {
                    syntax = {
                        variable = 'magenta.bright',
                        builtin2 = '',
                    },
                },
            },
            groups = {
                all = vim.tbl_extend('force', neovide_groups, {
                    Folded = { fg = '', bg = '' },
                    Conceal = { link = 'Directory' },

                    CursorLine = { bg = 'None' },

                    LspInlayHint = { style = 'italic' },
                    LspReferenceText = { fg = '', bg = '', style = 'bold,underline' },
                    LspReferenceRead = { fg = '', bg = '', style = 'bold,underline' },
                    LspReferenceWrite = { fg = '', bg = '', style = 'bold,underline' },
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
                    NeogitChangeAdded = { link = 'GitSignsAdd' },
                    NeogitChangeNewFile = { link = 'GitSignsAdd' },
                    NeogitChangeModified = { link = 'GitSignsChange' },
                    NeogitChangeDeleted = { link = 'GitSignsDelete' },
                    NeogitChangeRenamed = { link = 'DiagnosticInfo' },
                    NeogitChangeBothModified = { link = 'DiagnosticWarn' },
                    NeogitChangeUpdated = { link = 'GitSignsChange' },
                    NeogitChangeCopied = { link = 'GitSignsAdd' },

                    WhichKeyFloat = { bg = '' },

                    BqfPreviewRange = { link = 'Visual' },
                    BqfPreviewCursor = { link = 'Visual' },

                    BlinkCmpMenu = { link = 'NormalFloat' },
                    BlinkCmpMenuBorder = { link = 'FloatBorder' },
                    BlinkCmpMenuSelection = { link = 'Visual' },
                    BlinkCmpDocBorder = { link = 'FloatBorder' },
                    BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
                    BlinkCmpGhostText = { link = 'Comment' },

                    GrugFarResultsChangeIndicator = { link = 'DiffText' },
                    GrugFarResultsRemoveIndicator = { link = 'DiffDelete' },
                    GrugFarResultsAddIndicator = { link = 'DiffAdd' },

                    RipSubBackdrop = { bg = 'palette.bg0' },
                    SubstituteSubstituted = { link = 'Search' },

                    RainbowDelimiterRed = { fg = 'palette.red' },
                    RainbowDelimiterYellow = { fg = 'palette.yellow' },
                    RainbowDelimiterBlue = { fg = 'palette.blue' },
                    RainbowDelimiterOrange = { fg = 'palette.orange' },
                    RainbowDelimiterGreen = { fg = 'palette.green' },
                    RainbowDelimiterViolet = { fg = 'palette.magenta' },
                    RainbowDelimiterCyan = { fg = 'palette.cyan' },

                    NonText = { link = 'LineNr' },
                }),
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
            'nvim-tree/nvim-web-devicons',
        },
        event = 'VeryLazy',
        config = function()
            require('tiny-devicons-auto-colors').setup(require('nightfox.palette').load('nightfox'))
        end,
    },
}
