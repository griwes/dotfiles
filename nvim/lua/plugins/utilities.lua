return {
    {
        'krady21/compiler-explorer.nvim',
        event = 'VeryLazy',
        opts = {
            autocmd = {
                enable = true,
            },
            diagnostics = {
                virtual_text = true,
            }
        },
    },
    {
        -- TODO: configure keybinds
        'AckslD/nvim-FeMaco.lua',
        event = 'VeryLazy',
        opts = {
        },
    },
    {
        -- TODO: configure keybinds
        'riddlew/swap-split.nvim'
    },
    {
        -- TODO: configure
        'stevearc/oil.nvim',
        event = 'VeryLazy',
        opts = {
            columns = {
                'permissions',
                'size',
                'mtime',
                'icon',
            }
        },
        keys = {
        },
    },
    {
        'nacro90/numb.nvim',
        event = 'VeryLazy',
        opts = {
            number_only = true,
        },
    },
    {
        'tiagovla/buffercd.nvim',
        event = 'VeryLazy',
        opts = {
        },
    },
    {
        -- TODO: learn
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {
        },
        keys = {
            { 'ir', 'i[', mode = 'o' },
            { 'ar', 'a[', mode = 'o' },
            { 'ia', 'i<', mode = 'o' },
            { 'aa', 'a<', mode = 'o' },
        }
    },
    --[[ {
        -- TODO: enable when https://github.com/utilyre/sentiment.nvim/issues/11 is fixed
        "utilyre/sentiment.nvim",
        event = "VeryLazy",
        opts = {
        },
        init = function()
            vim.g.loaded_matchparen = 1
        end,
    }, ]]
    {
        'axieax/typo.nvim',
        event = 'VeryLazy',
        opts = {
        },
    },
    {
        'jghauser/mkdir.nvim',
    },
    {
        'axkirillov/hbac.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons'
        },
        event = 'VeryLazy',
        init = function()
            local actions = require("hbac.telescope.actions")
            local telescope_actions = require("telescope.actions")
            require('hbac').setup({
                threshold = 15,
                telescope = {
                    mappings = {
                        n = {
                            ["<CR>"] = telescope_actions.select_drop,
                            ["<C-CR>"] = telescope_actions.select_default,
                            ["<C-c>"] = actions.unpinned,
                            ["<C-x>"] = actions.delete_buffer,
                            ["<C-a>"] = actions.pin_all,
                            ["<C-u>"] = actions.unpin_all,
                            ["<C-y>"] = actions.toggle_selections,
                        },
                        i = {
                            ["<CR>"] = telescope_actions.select_drop,
                            ["<C-CR>"] = telescope_actions.select_default,
                            ["<C-c>"] = actions.close_unpinned,
                            ["<C-x>"] = actions.delete_buffer,
                            ["<C-a>"] = actions.pin_all,
                            ["<C-u>"] = actions.unpin_all,
                            ["<C-y>"] = actions.toggle_selections,
                        },
                    },
                },
            })
        end,
        keys = {
            { '<leader>bt',  '<cmd>Hbac telescope<cr>' },
            { '<leader>bpt', '<cmd>Hbac toggle_pin<cr>' },
            { '<leader>bpa', '<cmd>Hbac pin_all<cr>' },
            { '<leader>bpu', '<cmd>Hbac unpin_all<cr>' },
            { '<leader>bat', '<cmd>Hbac toggle_autoclose<cr>' },
            { '<leader>bax', '<cmd>Hbac close_unpinned<cr>' },
        }
    },
    {
        'famiu/bufdelete.nvim',
        event = 'VeryLazy',
        cmds = {
            'Bdelete',
            'Bwipeout',
        },
        keys = {
            { '<leader>bd', '<cmd>Bdelete<cr>' },
        }
    },
}
