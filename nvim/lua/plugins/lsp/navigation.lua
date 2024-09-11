return {
    {
        'SmiteshP/nvim-navbuddy',
        dependencies = {
            'neovim/nvim-lspconfig',
            'SmiteshP/nvim-navic',
            'MunifTanjim/nui.nvim',
            'numToStr/Comment.nvim',
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            window = {
                border = 'rounded',
                size = '75%',
                sections = {
                    left = {
                        size = '30%'
                    },
                    mid = {
                        size = '35%',
                    },
                    right = {
                    },
                },
            },
            lsp = {
                auto_attach = true,
            },
            node_markers = {
                enabled = true,
                icons = {
                    leaf = '  ',
                    leaf_selected = ' →  ',
                    branch = '   ',
                },
            },
            use_default_mappings = false,
        },
        config = function(_, opts)
            local actions = require('nvim-navbuddy.actions')

            opts.mappings = {
                ['<esc>'] = actions.close(),
                ['q'] = actions.close(),

                ['k'] = actions.next_sibling(),
                ['l'] = actions.previous_sibling(),

                ['j'] = actions.parent(),
                [';'] = actions.children(),
                ['0'] = actions.root(),

                ['nv'] = actions.visual_name(),
                ['v'] = actions.visual_scope(),

                ['ny'] = actions.yank_name(),
                ['y'] = actions.yank_scope(),

                ['ni'] = actions.insert_name(),
                ['i'] = actions.insert_scope(),

                ['na'] = actions.append_name(),
                ['a'] = actions.append_scope(),

                ['nr'] = actions.rename(),

                ['d'] = actions.delete(),

                ['zf'] = actions.fold_create(),
                ['zd'] = actions.fold_delete(),

                ['gc'] = actions.comment(),

                ['<enter>'] = actions.select(),

                ['K'] = actions.move_down(),
                ['L'] = actions.move_up(),

                ['p'] = actions.toggle_preview(),

                ['<C-v>'] = actions.vsplit(),
                ['<C-h>'] = actions.hsplit(),

                ['t'] = actions.telescope({
                    layout_strategy = 'horizontal',
                }),

                ['g?'] = actions.help(),
            }

            require('nvim-navbuddy').setup(opts)
        end,
        cmds = {
            'Navbuddy',
        },
        keys = {
            { '<leader>ln', '<cmd>Navbuddy<cr>' },
        },
    },
}
