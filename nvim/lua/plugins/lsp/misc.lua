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
                delay = 250,
                min_count_to_highlight = 2,
            })
        end,
    },
    {
        -- TODO: configure keybinds
        'smjonas/inc-rename.nvim',
        opts = {},
        keys = {
            { '<leader>lr', ':IncRename ' },
        },
    },
    {
        'griwes/lsp_lines.nvim',
        branch = 'griwes-patched',
        event = 'VeryLazy',
        config = function()
            require('lsp_lines').setup()
            vim.diagnostic.config({
                virtual_text = true,
                virtual_lines = false,
            })
            require('nvim-treesitter.ts_utils')

            vim.api.nvim_create_augroup('LspLinesToggles', { clear = true })
            local utils = require('utils.lsp')

            local seen_lsps = {}

            utils.add_callback(function(client, _)
                for _, seen_lsp in pairs(seen_lsps) do
                    if client.id == seen_lsp then
                        return
                    end
                end
                seen_lsps[#seen_lsps + 1] = client.id

                local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)
                vim.diagnostic.config({
                    virtual_text = false,
                    virtual_lines = { only_current_line = true },
                }, client_ns)
            end)

            vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
                group = 'LspLinesToggles',
                pattern = '*',
                callback = function()
                    for _, client in pairs(vim.lsp.get_clients()) do
                        local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)
                        vim.diagnostic.config({
                            virtual_text = false,
                            virtual_lines = false
                        }, client_ns)
                    end
                end
            })

            vim.api.nvim_create_autocmd({ 'InsertLeave' }, {
                group = 'LspLinesToggles',
                pattern = '*',
                callback = function()
                    for _, client in pairs(vim.lsp.get_clients()) do
                        local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)
                        vim.diagnostic.config({
                            virtual_text = false,
                            virtual_lines = { only_current_line = true },
                        }, client_ns)
                    end
                end
            })
        end
    },
    {
        'aznhe21/actions-preview.nvim',
        event = 'VeryLazy',
        init = function()
            local utils = require('utils.lsp')

            utils.add_callback(function(_, bufnr)
                local wk = require('which-key')

                wk.add({ { '<leader>lm', require('actions-preview').code_actions, desc = 'LSP code actions', buffer = bufnr } })
            end)
        end,
        opts = function()
            return {
                telescope = vim.tbl_extend('force', require('telescope.themes').get_dropdown(), {
                    layout_config = {
                        width = 250,
                        -- anchor = 'S',
                    }
                }),
            }
        end
    },
    {
        -- TODO: create convenient key mappings for common actions
        'luckasRanarison/clear-action.nvim',
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
        'lewis6991/hover.nvim',
        lazy = false,
        opts = {
            init = function()
                require('hover.providers.lsp')
                require('hover.providers.gh')
                require('hover.providers.gh_user')
                require('hover.providers.man')
            end,
            preview_opts = {
                border = 'rounded',
            },
            preview_window = true,
            title = true,
            mouse_providers = {
                'LSP'
            },
        },
        keys = {
            { 'K',  function() require('hover').hover({}) end },
            { 'gK', function() require('hover').hover_select({}) end },
        },
    },
    {
        'j-hui/fidget.nvim',
        opts = {
            progress = {
                suppress_on_insert = true,
                display = {
                    render_limit = 5,
                },
            },
            notification = {
                window = {
                    winblend = 70,
                    align = 'top',
                }
            }
        },
    },
}
