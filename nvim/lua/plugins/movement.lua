return {
    {
        'ethanholz/nvim-lastplace',
        event = 'VeryLazy',
        opts = {
        },
    },
    {
        'chrisgrieser/nvim-spider',
        event = 'VeryLazy',
        opts = {
            skipInsignificantPunctuation = false
        }
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        init = function()
            vim.cmd [[
                highlight! FlashMatch guifg=#f6b079 guibg=None gui=bold
                highlight! FlashLabel guifg=#7ad5d6 guibg=None gui=bold
            ]]
        end,
        opts = {
            label = {
                uppercase = false,
            },
            modes = {
                search = {
                    highlight = {
                        backdrop = true,
                    },
                    search = {
                        multi_window = false,
                        incremental = true,
                    },
                },
                char = {
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                '<leader>w',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump({
                        search = {
                            mode = function(str)
                                return '\\<' .. str
                            end,
                        },
                    })
                end,
                desc = 'Flash word jump'
            },
            {
                '<leader>f',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump({ search = { mode = 'fuzzy' } })
                end,
                desc = 'Flash fuzzy jump'
            },
            {
                '<leader>s',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = 'Flash search'
            },
        },
    },
    {
        'liangxianzhe/nap.nvim',
        event = 'VeryLazy',
        config = function()
            local nap = require('nap')

            nap.setup({
                next_repeat = '<M-]>',
                prev_repeat = '<M-[>',
                operators = {
                    ['d'] = {
                        next = { rhs = function() vim.diagnostic.goto_next({ float = false }) end, opts = { desc = 'Next diagnostic' } },
                        prev = { rhs = function() vim.diagnostic.goto_prev({ float = false  }) end, opts = { desc = 'Prev diagnostic' } },
                        mode = { 'n', 'v', 'o' },
                    },
                },
                exclude_default_operators = {'t', 'T'},
            })

            nap.map('c', nap.gitsigns())
            nap.map('r', nap.illuminate())
        end
    },
}
