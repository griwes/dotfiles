return {
    {
        'simonmclean/triptych.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            mappings = {
                nav_left = 'j',
                nav_right = ';',
                delete = {},
                add = {},
                copy = {},
                rename = {},
                rename_from_scratch = {},
                cut = {},
                paste = {},
            },
            options = {
                backdrop = 100,
                border = 'rounded',
                highlights = {
                    directory_names = 'Directory',
                },
            },
        },
        keys = {
            { '-', '<cmd>Triptych<cr>', desc = '󰉋 Open directory browser' },
        },
    },
}
