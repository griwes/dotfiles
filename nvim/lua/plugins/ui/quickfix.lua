return {
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf',
        opts = {
            preview = {
                winblend = vim.g.neovide and 100 or 75,
            },
            func_map = {
                prevhist = '',
                nexthist = '',
            },
        },
    },
    {
        'stevearc/quicker.nvim',
        ft = 'qf',
        opts = {
            keys = {
                {
                    '>',
                    function()
                        require('quicker').expand({ before = 2, after = 2, add_to_existing = true })
                    end,
                    desc = ' Expand quickfix context',
                },
                {
                    '<',
                    function()
                        require('quicker').collapse()
                    end,
                    desc = ' Collapse quickfix context',
                },
            },
            borders = {
                -- add spaces and extra header characters to add vertical padding around columns
                vert = ' ┃ ',
                -- strong headers separate results from different files
                strong_header = '━',
                strong_cross = '━╋━',
                strong_end = '┫',
                -- soft headers separate results within the same file
                soft_header = '╌',
                soft_cross = '╌╂╌',
                soft_end = '┨',
            },
        },
    },
}
