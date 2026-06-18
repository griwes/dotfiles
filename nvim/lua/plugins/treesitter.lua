local delimiter_highlights = {
    'RainbowDelimiterRed',
    'RainbowDelimiterYellow',
    -- 'RainbowDelimiterBlue',
    'RainbowDelimiterOrange',
    'RainbowDelimiterGreen',
    'RainbowDelimiterViolet',
    'RainbowDelimiterCyan',
}

local delimiter_priority = (vim.hl or vim.highlight).priorities.semantic_tokens + 1

local function treewalker(method)
    return function()
        require('treewalker')[method]()
    end
end

local function iswap(method)
    return function()
        require('iswap')[method]()
    end
end

return {
    {
        'romus204/tree-sitter-manager.nvim',
        lazy = false,
        build = function(plugin)
            require('utils.tree_sitter_manager_build').update_all(plugin)
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
        },
        opts = {
            auto_install = false,
            highlight = true,
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        opts = {
            select = {
                enable = true,
                lookahead = true,
                selection_modes = require('utils.textobjects').selection_modes(),
            },
            swap = {
                enable = true,
            },
            move = {
                set_jumps = true,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter-textobjects').setup(opts)
            require('utils.textobjects').setup_bracket_nav()
        end,
        keys = function()
            local ret = {
                {
                    '<C-M-;>',
                    function()
                        require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
                    end,
                    desc = '󰏪 Swap parameter next',
                },
                {
                    '<C-M-j>',
                    function()
                        require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
                    end,
                    desc = '󰏪 Swap parameter previous',
                },
            }

            require('utils.textobjects').each(function(spec)
                ret[#ret + 1] = {
                    'a' .. spec.key,
                    function()
                        require('nvim-treesitter-textobjects.select').select_textobject(spec.capture .. '.outer')
                    end,
                    desc = spec.icon .. 'Select around ' .. spec.label,
                    mode = { 'o', 'x' },
                }
                ret[#ret + 1] = {
                    'i' .. spec.key,
                    function()
                        require('nvim-treesitter-textobjects.select').select_textobject(spec.capture .. '.inner')
                    end,
                    desc = spec.icon .. 'Select inside ' .. spec.label,
                    mode = { 'o', 'x' },
                }
            end)

            return ret
        end,
    },
    {
        'aaronik/treewalker.nvim',
        opts = {
            jumplist = 'left',
        },
        keys = {
            {
                '<C-j>',
                treewalker('move_out'),
                desc = '󰁝 Move out to ancestor node',
                mode = 'n',
                silent = true,
            },
            {
                '<C-k>',
                treewalker('move_down'),
                desc = '󰁔 Move to next sibling node',
                mode = 'n',
                silent = true,
            },
            {
                '<C-l>',
                treewalker('move_up'),
                desc = '󰁝 Move to previous sibling node',
                mode = 'n',
                silent = true,
            },
            {
                '<C-;>',
                treewalker('move_in'),
                desc = '󰁔 Move in to child node',
                mode = 'n',
                silent = true,
            },
            {
                '<C-M-k>',
                treewalker('swap_down'),
                desc = '󰁔 Swap structural node down',
                mode = 'n',
                silent = true,
            },
            {
                '<C-M-l>',
                treewalker('swap_up'),
                desc = '󰁝 Swap structural node up',
                mode = 'n',
                silent = true,
            },
        },
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        branch = 'master',
        event = 'VeryLazy',
        enabled = true,
        opts = {
            multiwindow = true,
            separator = '═',
            zindex = 5,
        },
        keys = {
            {
                'hzc',
                function()
                    require('treesitter-context').toggle()
                end,
                desc = '󰅩 Toggle context display',
            },
            {
                'gjc',
                function()
                    require('treesitter-context').go_to_context(vim.v.count1)
                end,
                desc = '󰁔 Jump to higher context',
            },
        },
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'VeryLazy',
        dependencies = {
            'romus204/tree-sitter-manager.nvim',
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
                scope = {
                    enabled = true,
                    injected_languages = true,
                    show_start = true,
                    show_end = true,
                    show_exact_scope = true,
                    highlight = delimiter_highlights,
                },
            })

            local hooks = require('ibl.hooks')
            hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
        end,
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        lazy = false,
        dependencies = {
            'romus204/tree-sitter-manager.nvim',
        },
        config = function()
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = require('rainbow-delimiters').strategy['global'],
                    ['rust'] = require('rainbow-delimiters').strategy['global'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                    ['lua'] = 'rainbow-blocks',
                },
                highlight = delimiter_highlights,
                priority = {
                    [''] = delimiter_priority,
                },
            }
        end,
    },
    {
        'danymat/neogen',
        opts = {
            snippet_engine = 'luasnip_selection',
        },
        config = function(_, opts)
            local snippet = require('neogen.snippet')

            snippet.engines.luasnip_selection = function(snip, pos)
                local ok, luasnip = pcall(require, 'luasnip')
                if not ok then
                    require('neogen.utilities.helpers').notify('Luasnip not found, aborting...', vim.log.levels.ERROR)
                    return
                end

                local types = require('luasnip.util.types')
                vim.fn.append(pos[1], '')

                local parsed = luasnip.s(
                    '',
                    luasnip.parser.parse_snippet(nil, table.concat(snip, '\n'), {
                        trim_empty = false,
                        dedent = false,
                    }),
                    {
                        child_ext_opts = {
                            [types.insertNode] = {
                                passive = { hl_group = require('neogen.config').get().placeholders_hl },
                            },
                        },
                        merge_child_ext_opts = true,
                    }
                )

                require('utils.luasnip_selection').snip_expand(parsed, { pos = pos })
            end

            require('neogen').setup(opts)
        end,
        keys = {
            {
                'hDd',
                function()
                    require('neogen').generate({})
                end,
                desc = '󰙨 Generate docs',
            },
            {
                'hDf',
                function()
                    require('neogen').generate({ type = 'func' })
                end,
                desc = '󰙨 Generate docs for surrounding function',
            },
            {
                'hDc',
                function()
                    require('neogen').generate({ type = 'class' })
                end,
                desc = '󰙨 Generate docs for surrounding class',
            },
        },
    },
    {
        'mizlan/iswap.nvim',
        opts = {
            hl_flash = 'IncSearch',
            hl_grey = 'Comment',
            hl_selection = 'Visual',
            hl_snipe = 'FlashLabel',
            move_cursor = true,
        },
        keys = {
            { 'gsa', iswap('iswap_with'), desc = '󰓡 Swap current argument' },
            { 'gsA', iswap('iswap'), desc = '󰓡 Swap chosen arguments' },
            { 'gsn', iswap('iswap_node_with'), desc = '󰆧 Swap current node' },
            { 'gsN', iswap('iswap_node'), desc = '󰆧 Swap chosen nodes' },
            { 'gma', iswap('imove_with'), desc = '󰓡 Move current argument' },
            { 'gmA', iswap('imove'), desc = '󰓡 Move chosen arguments' },
            { 'gmn', iswap('imove_node_with'), desc = '󰆧 Move current node' },
            { 'gmN', iswap('imove_node'), desc = '󰆧 Move chosen nodes' },
        },
    },
    {
        'Wansmer/treesj',
        dependencies = { 'romus204/tree-sitter-manager.nvim' },
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            {
                'hnn',
                function()
                    require('treesj').toggle({ split = { recursive = true } })
                end,
                desc = '󰤻 Toggle split/join',
            },
            {
                'hnj',
                function()
                    require('treesj').join({ split = { recursive = true } })
                end,
                desc = '󰤻 Join node',
            },
            {
                'hns',
                function()
                    require('treesj').split({ split = { recursive = true } })
                end,
                desc = '󰤻 Split node',
            },
        },
    },
}
