return {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = {
                    enable = true,
                },
            })

            vim.api.nvim_create_augroup('TreesitterToggles', { clear = true })

            vim.api.nvim_create_autocmd('InsertEnter', {
                command = 'TSBufDisable highlight',
            })
            vim.api.nvim_create_autocmd('InsertLeave', {
                command = 'TSBufEnable highlight',
            })
        end,
    },
    {
        'andersevenrud/nvim_context_vt',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter'
        },
        opts = {
            prefix = '»',
            highlight = 'Comment',
        }
    },
    {
        'RRethy/nvim-treesitter-textsubjects',
        config = function()
            require('nvim-treesitter.configs').setup({
                textsubjects = {
                    enable = true,
                    prev_selection = ',', -- (Optional) keymap to select the previous selection
                    keymaps = {
                        ['.'] = 'textsubjects-smart',
                        ['@'] = 'textsubjects-container-outer',
                        ['i@'] = 'textsubjects-container-inner',
                        ['p'] = '@parameter',
                    },
                },
            })
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        branch = 'current-indent',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'HiPhish/rainbow-delimiters.nvim',
        },
        config = function()
            local highlight = {
                'RainbowDelimiterRed',
                'RainbowDelimiterYellow',
                'RainbowDelimiterBlue',
                'RainbowDelimiterOrange',
                'RainbowDelimiterGreen',
                'RainbowDelimiterViolet',
                'RainbowDelimiterCyan',
            }

            local scope_overrides = {
                cpp = {
                    compound_statement = false,
                    statement = true,
                },
                lua = {
                    field = true,
                    variable_declaration = true,
                    function_call = true,
                },
            }

            local sl = require('ibl.scope_languages')
            for k, v in pairs(scope_overrides) do
                sl[k] = vim.tbl_extend('force', sl[k], v)
            end

            require('ibl').setup({
                indent = {
                    char = '│',
                    smart_indent_cap = true,
                },
                current_indent = {
                    enabled = false,
                    show_start = false,
                    show_end = false,
                    highlight = highlight,
                },
                scope = {
                    enabled = true,
                    injected_languages = true,
                    show_start = true,
                    show_end = true,
                    show_exact_scope = true,
                    highlight = highlight,
                },
            })

            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
        keys = {
            { '<leader>lts', '<cmd>IBLToggleScope<CR>', 'Toggle precise scope highlighting' },
        },
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        lazy = false,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = function()
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = require('rainbow-delimiters').strategy['global'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end
    },
    {
        'ziontee113/syntax-tree-surfer',
        opts = {},
        keys = {
            {
                '<A-l>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapUpNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<A-k>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapDownNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<A-j>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapCurrentNodePrevNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<A-;>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapCurrentNodeNextNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },

            { 'vr',    '<cmd>STSSelectMasterNode<cr>',      mode = 'n', noremap = true, silent = true },
            { 'vc',    '<cmd>STSSelectCurrentNode<cr>',     mode = 'n', noremap = true, silent = true },
            { '<C-;>', '<cmd>STSSelectNextSiblingNode<cr>', mode = 'x', noremap = true, silent = true },
            { '<C-j>', '<cmd>STSSelectPrevSiblingNode<cr>', mode = 'x', noremap = true, silent = true },
            { '<C-l>', '<cmd>STSSelectParentNode<cr>',      mode = 'x', noremap = true, silent = true },
            { '<C-k>', '<cmd>STSSelectChildNode<cr>',       mode = 'x', noremap = true, silent = true },
            { '<A-j>', '<cmd>STSSwapNextVisual<cr>',        mode = 'x', noremap = true, silent = true },
            { '<A-;>', '<cmd>STSSwapPrevVisual<cr>',        mode = 'x', noremap = true, silent = true },
        }
    }
}
