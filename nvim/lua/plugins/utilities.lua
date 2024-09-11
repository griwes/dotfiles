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
            },
        },
    },
    {
        -- TODO: configure keybinds
        'AckslD/nvim-FeMaco.lua',
        event = 'VeryLazy',
        opts = {},
    },
    {
        -- TODO: configure keybinds
        'riddlew/swap-split.nvim',
    },
    {
        -- TODO: configure
        'stevearc/oil.nvim',
        opts = {
            constrain_cursor = 'editable',
            columns = {
                {
                    'permissions',
                    highlight = function(permission_str)
                        local permission_hlgroups = {
                            ['-'] = 'NonText',
                            ['r'] = 'DiagnosticSignWarn',
                            ['w'] = 'DiagnosticSignError',
                            ['x'] = 'DiagnosticSignOk',
                            ['t'] = 'DiagnosticSignInfo',
                        }

                        local hls = {}
                        for i = 1, #permission_str do
                            local char = permission_str:sub(i, i)
                            table.insert(hls, { permission_hlgroups[char], i - 1, i })
                        end
                        return hls
                    end,
                },
                { 'size',  highlight = 'Number' },
                { 'mtime', highlight = 'Special' },
                { 'icon' },
            },
            win_options = {
                number = false,
                relativenumber = false,
                signcolumn = 'no',
                foldcolumn = '0',
                statuscolumn = '',
            },
        },
        cmd = { 'Oil' },
        keys = {
            { '-', '<cmd>Oil<cr>', desc = 'Open Oil' },
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
        opts = {},
    },
    {
        'chrisgrieser/nvim-various-textobjs',
        event = 'VeryLazy',
        opts = {
            useDefaultKeymaps = true,
        },
    },
    {
        -- TODO: learn
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {},
        keys = {
            { 'ir', 'i[', mode = 'o' },
            { 'ar', 'a[', mode = 'o' },
            { 'ia', 'i<', mode = 'o' },
            { 'aa', 'a<', mode = 'o' },
        },
    },
    {
        -- TODO: learn
        'gbprod/substitute.nvim',
        event = 'VeryLazy',
        opts = {
            on_substitute = function() require("yanky.integration").substitute() end,
        },
        keys = {
            {
                's',
                function()
                    require('substitute').operator()
                end,
            },
            {
                'ss',
                function()
                    require('substitute').line()
                end,
            },
            {
                'S',
                function()
                    require('substitute').eol()
                end,
            },
            {
                's',
                function()
                    require('substitute').visual()
                end,
                mode = 'x',
            },

            {
                'sx',
                function()
                    require('substitute.exchange').operator()
                end,
            },
            {
                'sxx',
                function()
                    require('substitute.exchange').line()
                end,
            },
            {
                'X',
                function()
                    require('substitute.exchange').visual()
                end,
                mode = 'x',
            },
            {
                'sxc',
                function()
                    require('substitute.exchange').cancel()
                end,
            },

            {
                '<M-s>',
                function()
                    require('substitute.range').operator()
                end,
            },
            {
                '<M-s>',
                function()
                    require('substitute.range').visual()
                end,
                mode = 'x',
            },
            {
                '<M-s>w',
                function()
                    require('substitute.range').word()
                end,
            },
        },
    },
    --[[ {
        -- TODO: enable when https://github.com/utilyre/sentiment.nvim/issues/11 is fixed
        'utilyre/sentiment.nvim',
        event = 'VeryLazy',
        opts = {
        },
        init = function()
            vim.g.loaded_matchparen = 1
        end,
    }, ]]
    {
        'axieax/typo.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        'jghauser/mkdir.nvim',
    },
    {
        'axkirillov/hbac.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        event = 'VeryLazy',
        init = function()
            local actions = require('hbac.telescope.actions')
            local telescope_actions = require('telescope.actions')
            require('hbac').setup({
                threshold = 15,
                telescope = {
                    use_default_mappings = false,
                    mappings = {
                        n = {
                            ['<CR>'] = telescope_actions.select_drop,
                            ['<C-CR>'] = telescope_actions.select_default,
                            ['c'] = actions.close_unpinned,
                            ['x'] = actions.delete_buffer,
                            ['a'] = actions.pin_all,
                            ['u'] = actions.unpin_all,
                            ['<Space>'] = actions.toggle_pin,
                        },
                        i = {
                            ['<CR>'] = telescope_actions.select_drop,
                            ['<C-CR>'] = telescope_actions.select_default,
                            ['<C-c>'] = actions.close_unpinned,
                            ['<C-x>'] = actions.delete_buffer,
                            ['<C-a>'] = actions.pin_all,
                            ['<C-u>'] = actions.unpin_all,
                            ['<C-Space>'] = actions.toggle_pin,
                        },
                    },
                },
            })

            require('telescope').load_extension('hbac')
        end,
        keys = {
            { '<leader>bt',  '<cmd>Telescope hbac buffers<cr>' },
            { '<leader>bpt', '<cmd>silent! Hbac toggle_pin<cr>' },
            { '<leader>bpa', '<cmd>Hbac pin_all<cr>' },
            { '<leader>bpu', '<cmd>Hbac unpin_all<cr>' },
            { '<leader>bat', '<cmd>Hbac toggle_autoclose<cr>' },
            { '<leader>bax', '<cmd>Hbac close_unpinned<cr>' },
        },
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
        },
    },
}
