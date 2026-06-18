return {
    {
        'nvim-zh/colorful-winsep.nvim',
        event = 'WinLeave',
        opts = {
            border = 'rounded',
            animate = {
                enabled = 'progressive',
                progressive = {
                    vertical_delay = 10,
                    horizontal_delay = 1,
                },
            },
            indicator_for_2wins = {
                position = 'both',
                symbols = {
                    start_left = '>',
                    end_left = '>',
                    start_down = 'ʌ',
                    end_down = 'ʌ',
                    start_up = 'v',
                    end_up = 'v',
                    start_right = '<',
                    end_right = '<',
                },
            },
        },
    },
}
