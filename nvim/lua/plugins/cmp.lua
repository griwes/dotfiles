return {
    {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        opts = {
            history = true,
        }
    },
    {
        'doxnit/cmp-luasnip-choice',
        opts = {},
    },
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        opts = {
        },
    },
    {
        'hrsh7th/nvim-cmp',
        event = 'VeryLazy',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'rcarriga/cmp-dap', -- TODO: configure
            'onsails/lspkind.nvim',
            'petertriho/cmp-git',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup({
                experimental = {
                    ghost_text = { hl_group = 'Comment' },
                },
                performance = {
                    confirm_resolve_timeout = 1,
                    throttle = 1,
                },
                enabled = function()
                    -- disable completion in comments
                    local context = require('cmp.config.context')
                    -- keep command mode completion enabled when cursor is in a comment
                    if vim.api.nvim_get_mode().mode == 'c' then
                        return true
                    else
                        return not context.in_treesitter_capture('comment')
                            and not context.in_syntax_group('Comment')
                    end
                end,
                matching = {
                    disallow_fuzzy_matching = true,
                    disallow_fullfuzzy_matching = true,
                    disallow_partial_fuzzy_matching = false,
                    disallow_prefix_unmatching = true,
                    disallow_partial_matching = true,
                },
                formatting = {
                    format = require('lspkind').cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '…',
                    }),
                },
                preselect = cmp.PreselectMode.None,
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered {
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                    },
                    documentation = cmp.config.window.bordered {
                        winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
                    },
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        ---@diagnostic disable-next-line: assign-type-mismatch
                        cmp.config.compare.recently_used,
                        require('clangd_extensions.cmp_scores'),
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-s>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if cmp.complete_common_string() then
                                cmp.complete({ config = {
                                    matching = {
                                        disallow_fuzzy_matching = true,
                                        disallow_fullfuzzy_matching = false,
                                        disallow_partial_fuzzy_matching = false,
                                        disallow_prefix_unmatching = false,
                                        disallow_partial_matching = false,
                                    }
                                }})
                            else
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            end
                        elseif luasnip.expandable() then
                            luasnip.expand()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'git' },
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })

            cmp.get_entries()

            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    {
                        name = 'cmdline',
                        option = {
                            ignore_cmds = { 'Man', '!' }
                        }
                    }
                })
            })

            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

            require('cmp_git').setup()
        end
    },
}
