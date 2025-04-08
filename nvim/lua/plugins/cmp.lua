return {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        init = function()
            local npairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            local cond = require('nvim-autopairs.conds')

            local function rule2(a1, ins, a2, lang)
                npairs.add_rule(Rule(ins, ins, lang)
                    :with_pair(function(opts)
                        return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    :with_del(function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
                    end))
            end
            rule2('(', ' ', ')')
            rule2('{', ' ', '}')

            for _, punct in pairs({ ',', ';' }) do
                npairs.add_rule(Rule('', punct)
                    :with_move(function(opts)
                        return opts.char == punct
                    end)
                    :with_pair(function()
                        return false
                    end)
                    :with_del(function()
                        return false
                    end)
                    :with_cr(function()
                        return false
                    end)
                    :use_key(punct))
            end
        end,
        opts = {},
    },
    {
        'saghen/blink.compat',
        dependencies = {
        },
        opts = {
            impersonate_nvim_cmp = true,
        }
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'xzbdmw/colorful-menu.nvim',
            'L3MON4D3/LuaSnip',
            'saghen/blink.compat',
        },
        version = '*',

        opts = {
            snippets = {
                preset = 'luasnip',
            },

            keymap = {
                preset = 'none',
                ['<C-space>'] = { 'show' },
                ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Esc>'] = { 'hide_signature', 'cancel', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-s>'] = { 'scroll_documentation_up', 'fallback' },
                ['<Enter>'] = { 'accept', 'fallback' },
                ['<C-Enter>'] = { 'select_and_accept' },
            },

            cmdline = {
                enabled = true,

                keymap = {
                    ['<Enter>'] = { 'fallback' },
                    ['<Down>'] = { 'fallback' },
                    ['<Up>'] = { 'fallback' },
                },

                completion = {
                    ghost_text = {
                        enabled = true,
                    },

                    menu = {
                        auto_show = true,
                    },
                },
            },

            --[[ term = {
                enabled = true,
                sources = { 'path', 'buffer' },
            }, ]]

            completion = {
                keyword = {
                    range = 'full',
                },

                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },

                menu = {
                    border = 'rounded',
                    max_height = 15,

                    draw = {
                        treesitter = { 'lsp' },

                        columns = { { 'source_name' }, { 'kind_icon' }, { 'label' } },

                        components = {
                            label = {
                                text = function(ctx)
                                    return require('colorful-menu').blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require('colorful-menu').blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },

                documentation = {
                    auto_show = true,
                    window = {
                        border = 'rounded',
                    },
                },

                ghost_text = {
                    enabled = true,
                    show_without_selection = false,
                },
            },

            signature = {
                enabled = true,

                trigger = {
                    show_on_keyword = true,
                    show_on_insert = true,
                },

                window = {
                    border = 'rounded',
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },

                providers = {
                }
            },
        },
        opts_extend = { 'sources.default' },
    },
}
