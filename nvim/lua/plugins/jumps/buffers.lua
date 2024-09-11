return {
    {
        'kwkarlwang/bufjump.nvim',
        opts = {
            backward = '',
            forward = '',
        },
        keys = {
            { '<M-o>', function() require('bufjump').backward() end, desc = 'Jump to previous file in jumplist' },
            { '<M-i>', function() require('bufjump').forward() end,  desc = 'Jump to next file in jumplist' },
        }
    },
    {
        'leath-dub/snipe.nvim',
        opts = {
            ui = {
                position = 'cursor',
            },
            navigate = {
                next_page = 'K',
                prev_page = 'J',
            },
            sort = 'last',
        },
        keys = {
            { 'gjb', function() require('snipe').open_buffer_menu() end, desc = 'Open Snipe buffer menu' }
        },
    }
}
