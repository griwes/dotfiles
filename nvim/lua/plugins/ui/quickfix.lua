return {
    {
        'kevinhwang91/nvim-bqf',
        event = 'VeryLazy',
        opts = {
            preview = {
                winblend = 75,
            },
        },
        keys = {
            { '<leader>co', function()
                require('edgy.edgebar').stop = true
                vim.cmd.copen()
                require('edgy.edgebar').stop = false
                require('bqf.main').enable()
            end },
            { '<leader>cc', '<cmd>cclose<cr>' },
        }
    },
    {
        'stevearc/quicker.nvim',
        event = 'VeryLazy',
        opts = {
            keys = {
                {
                    ">",
                    function()
                        require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = "Expand quickfix context",
                },
                {
                    "<",
                    function()
                        require("quicker").collapse()
                    end,
                    desc = "Collapse quickfix context",
                },
            },
            borders = {
                -- add spaces and extra header characters to add vertical padding around columns
                vert = " ┃ ",
                -- strong headers separate results from different files
                strong_header = "━",
                strong_cross = "━╋━",
                strong_end = "┫",
                -- soft headers separate results within the same file
                soft_header = "╌",
                soft_cross = "╌╂╌",
                soft_end = "┨",
            },
        },
    }
}
