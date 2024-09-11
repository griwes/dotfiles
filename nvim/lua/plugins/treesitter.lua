local highlight = {
    'TSRainbowRed',
    'TSRainbowYellow',
    -- 'TSRainbowBlue',
    'TSRainbowOrange',
    'TSRainbowGreen',
    'TSRainbowViolet',
    'TSRainbowCyan',
}

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
                        ['a@'] = 'textsubjects-container-outer',
                        ['i@'] = 'textsubjects-container-inner',
                    },
                },
            })
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'HiPhish/rainbow-delimiters.nvim',
        },
        config = function()
            local scope_overrides = {
                cpp = {
                    compound_statement = false,
                    statement = true,
                    definition = true,
                    declaration = true,
                    field_declaration = true,
                    switch_statement = true,
                    case_statement = true,
                    call_expression = true,
                    namespace_definition = true,
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
                    priority = 9,
                },
                --[[ current_indent = {
                    enabled = false,
                    show_start = false,
                    show_end = false,
                    highlight = highlight,
                }, ]]
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
                highlight = highlight,
            }
        end
    },
    {
        'ziontee113/syntax-tree-surfer',
        opts = {},
        keys = {
            {
                '<C-A-l>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapUpNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<C-A-k>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapDownNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<C-A-j>',
                function()
                    vim.opt.opfunc = 'v:lua.STSSwapCurrentNodePrevNormal_Dot'
                    return 'g@l'
                end,
                silent = true,
                expr = true
            },
            {
                '<C-A-;>',
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
            { '<C-A-j>', '<cmd>STSSwapPrevVisual<cr>',        mode = 'x', noremap = true, silent = true },
            { '<C-A-;>', '<cmd>STSSwapNextVisual<cr>',        mode = 'x', noremap = true, silent = true },
        }
    },
    {
        'danymat/neogen',
        opts = {
            snippet_engine = 'luasnip',
        },
        keys = {
            { '<leader>ldd', function() require('neogen').generate({}) end, desc = 'Generate docs' },
            { '<leader>ldf', function() require('neogen').generate({ type = 'func' }) end, desc = 'Generate docs for surrounding function' },
            { '<leader>ldc', function() require('neogen').generate({ type = 'class' }) end, desc = 'Generate docs for surrounding class' },
            { '<leader>ldt', function() require('neogen').generate({ type = 'class' }) end, desc = 'Generate docs for surrounding type' },
        },
    },
    {
          'mizlan/iswap.nvim',
          opts = {
              hl_snipe = 'ErrorMsg',
          },
          keys = {
              { '<leader>is', '<cmd>ISwapWith<cr>' },
              { '<leader>iis', '<cmd>ISwap<cr>' },
              { '<leader>in', '<cmd>ISwapNodeWith<cr>' },
              { '<leader>iin', '<cmd>ISwapNode<cr>' },
              { '<leader>im', '<cmd>IMoveWith<cr>' },
              { '<leader>iim', '<cmd>IMove<cr>' },
              { '<leader>iN', '<cmd>IMoveNodeWith<cr>' },
              { '<leader>iiN', '<cmd>IMoveNode<cr>' },
          }
    }
}
