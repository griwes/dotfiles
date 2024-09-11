return {
    {
        'folke/edgy.nvim',
        lazy = false,
        opts = {
            options = {
                left = { size = 40 },
                right = { size = 40 },
                top = { size = 12 },
                bottom = { size = 12 },
            },

            animate = {
                enabled = false,
            },

            left = {
                {
                    ft = 'neo-tree',
                    title = 'Files',
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == '' and
                            vim.b[buf].neo_tree_source == 'filesystem'
                    end,
                    pinned = true,
                    open = 'Neotree reveal filesystem left',
                    size = {
                        height = 0.5,
                    },
                },
                {
                    ft = 'neo-tree',
                    title = 'Buffers',
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == '' and
                            vim.b[buf].neo_tree_source == 'buffers'
                    end,
                    pinned = true,
                    open = 'Neotree buffers top',
                },
                {
                    ft = 'neo-tree',
                    title = 'Git Status',
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == '' and
                            vim.b[buf].neo_tree_source == 'git_status'
                    end,
                    pinned = true,
                    open = 'Neotree git_status bottom',
                },
                {
                    ft = 'neo-tree',
                    title = 'Neo-tree',
                    filter = function(_, win)
                        return vim.api.nvim_win_get_config(win).relative == ''
                    end,
                }
            },
            right = {
                {
                    ft = 'trouble',
                    title = 'LSP Definitions',
                    filter = function(_, win)
                        return (vim.w[win].trouble or {}).mode == 'lsp_definitions'
                    end,
                    pinned = true,
                    open = 'Trouble lsp_definitions',
                    size = {
                        height = 10,
                    },
                },
                {
                    ft = 'trouble',
                    title = 'LSP References',
                    filter = function(_, win)
                        return (vim.w[win].trouble or {}).mode == 'lsp_references'
                    end,
                    pinned = true,
                    open = 'Trouble lsp_references',
                    size = {
                        height = 0.3,
                    },
                },
                {
                    ft = 'trouble',
                    title = 'LSP Document Symbols',
                    filter = function(_, win)
                        return (vim.w[win].trouble or {}).mode == 'lsp_document_symbols'
                    end,
                    pinned = true,
                    open = 'Trouble lsp_document_symbols',
                },
                'trouble',
            },
            bottom = {
                {
                    ft = 'trouble',
                    title = 'Diagnostics',
                    filter = function(_, win)
                        return (vim.w[win].trouble or {}).mode == 'diagnostics'
                    end,
                    --pinned = true,
                    open = 'Trouble diagnostics',
                },
                {
                    ft = 'trouble',
                    title = 'Quickfix Tree',
                    filter = function(_, win)
                        return (vim.w[win].trouble or {}).mode == 'quickfix'
                    end,
                    open = 'Trouble quickfix',
                },
                {
                    ft = 'qf',
                    title = 'Quickfix List',
                    filter = function(_, win)
                        return vim.api.nvim_win_get_config(win).relative == ''
                    end,
                    open = 'co',
                    size = {
                        width = 0.5,
                    }
                },
            },
            top = {
            },

            close_when_all_hidden = false,
        },
        keys = {
            { '<leader>ej', function() require('edgy').toggle('left') end },
            { '<leader>ek', function()
                vim.cmd.cclose()
                vim.cmd.lclose()
                require('edgy').toggle('bottom')
            end },
            { '<leader>el', function() require('edgy').toggle('top') end },
            { '<leader>e;', function() require('edgy').toggle('right') end },
        }
    }
}
