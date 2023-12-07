return {
    {
        'RRethy/vim-illuminate',
        event = 'VeryLazy',
        config = function()
            require('illuminate').configure({
                providers = {
                    -- Because the plugin seems to always get references from everywhere,
                    -- and because LSPs don't understand injected languages, enabling this
                    -- makes the plugin not recognize TS nodes from the injected language.
                    -- TODO: file a bug about this, but for now, just disable the LSP provider.
                    --
                    -- 'lsp',
                    'treesitter',
                    'regex',
                },
                min_count_to_highlight = 2,
            })
        end,
    },
    {
        -- TODO: configure keybinds
        'smjonas/inc-rename.nvim',
        opts = {},
    },
    {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        event = 'VeryLazy',
        config = function()
            require('lsp_lines').setup()
            vim.diagnostic.config({
                virtual_lines = false,
                virtual_text = true,
            })
            require('nvim-treesitter.ts_utils')

            vim.cmd [[
                highlight DiagnosticVirtualTextError guibg=None
                highlight DiagnosticVirtualTextWarn guibg=None
                highlight DiagnosticVirtualTextInfo guibg=None
                highlight DiagnosticVirtualTextHint guibg=None
            ]]

            vim.api.nvim_create_augroup('LspLinesToggles', { clear = true })
            local utils = require('utils.lsp')

            utils.add_callback(function(_, client, bufnr)
                local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)

                vim.diagnostic.config({
                    virtual_text = false,
                    virtual_lines = { only_current_line = true },
                }, client_ns)

                vim.api.nvim_create_autocmd({ 'LspAttach', 'InsertEnter' }, {
                    group = 'LspLinesToggles',
                    buffer = bufnr,
                    callback = function()
                        vim.diagnostic.config({
                            virtual_text = false,
                            virtual_lines = false
                        }, client_ns)
                    end
                })
                vim.api.nvim_create_autocmd('InsertLeave', {
                    group = 'LspLinesToggles',
                    buffer = bufnr,
                    callback = function()
                        vim.diagnostic.config({
                            virtual_text = false,
                            virtual_lines = { only_current_line = true }
                        }, client_ns)
                    end
                })
            end)
        end
    },
    {
        'aznhe21/actions-preview.nvim',
        event = 'VeryLazy',
        init = function()
            local utils = require('utils.lsp')

            utils.add_callback(function(_, _, bufnr)
                local wk = require('which-key')

                wk.register({
                    l = {
                        m = { require("actions-preview").code_actions, 'LSP code actions' },
                    },
                }, { prefix = '<leader>', buffer = bufnr })
            end)
        end,
        opts = {
            telescope = {
                sorting_strategy = "descending",
            },
        }
    },
    {
        -- TODO: create convenient key mappings for common actions
        "luckasRanarison/clear-action.nvim",
        opts = {
            signs = {
                show_label = true,
                label_fmt = function(actions)
                    for _, action in ipairs(actions) do
                        if action.kind and vim.startswith(action.kind, 'quickfix') then
                            return action.title
                        end
                    end
                    return ''
                end,
                highlights = {
                    label = 'Comment',
                },
            },
        }
    },
    {
        "lewis6991/hover.nvim",
        opts = {
            init = function()
                require("hover.providers.lsp")
                require('hover.providers.gh')
                require('hover.providers.gh_user')
                require('hover.providers.man')
            end,
            preview_opts = {
                border = 'rounded',
            },
            preview_window = false,
            title = true,
        },
        keys = {
            { 'K',  function() require('hover').hover() end },
            { 'gK', function() require('hover').hover_select() end },
        },
    },
    {
        'dnlhc/glance.nvim',
        event = 'VeryLazy',
        opts = {
            border = {
                enable = true,
            },
            mappings = {
                list = {
                    ['h'] = nil,
                    ['j'] = function() require('glance').actions.close_fold() end,
                    ['k'] = function() require('glance').actions.next() end,
                    ['l'] = function() require('glance').actions.previous() end,
                    [';'] = function() require('glance').actions.open_fold() end,
                }
            }
        },
        keys = {
            { 'gpr', '<cmd>Glance references<cr>' },
            { 'gpd', '<cmd>Glance definitions<cr>' },
            { 'gpt', '<cmd>Glance type_definitions<cr>' },
            { 'gli', '<cmd>Glance implementations<cr>' },
        }
    },
}
