return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
            'saifulapm/neotree-file-nesting-config',
        },
        opts = function()
            return {
                hide_root_node = true,
                retain_hidden_root_indent = true,
                default_component_configs = {
                    indent = {
                        with_expanders = true,
                        expander_collapsed = '',
                        expander_expanded = '',
                    },
                },
                nesting_rules = require('neotree-file-nesting-config').nesting_rules,
                sources = {
                    'filesystem',
                    'buffers',
                    'git_status',
                },
                auto_clean_after_session_restore = true,
                close_if_last_window = true,
                default_source = 'last',
                popup_border_style = 'rounded',
                window = {
                    width = 45,
                    mappings = {
                        ['l'] = 'noop',
                        ['I'] = 'focus_preview',
                        ['Z'] = 'expand_all_nodes',
                    },
                },
                filesystem = {
                    follow_current_file = {
                        enabled = true,
                    },
                    filtered_items = {
                        show_hidden_count = false,
                        never_show = {
                            '.DS_Store',
                        },
                    },
                },
                source_selector = {
                    winbar = false,
                },
            }
        end,
        keys = {
            { '<leader>tf', '<cmd>Neotree reveal filesystem float<cr>' },
            { '<leader>tg', '<cmd>Neotree reveal git_status float<cr>' },
            { '<leader>tb', '<cmd>Neotree reveal buffers float<cr>' },
        },
    },
    {
        'mrbjarksen/neo-tree-diagnostics.nvim',
        dependencies = {
            'nvim-neo-tree/neo-tree.nvim'
        },
        event = 'VeryLazy',
    }
}
