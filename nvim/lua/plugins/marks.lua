return {
    {
        -- TODO: configure bookmark groups to give them some sort of meaning?
        'chentoast/marks.nvim',
        event = 'VeryLazy',
        opts = {
            builtin_marks = { '.', '<', '>', '^' },
            excluded_buftypes = {
                'nofile',
                'prompt',
            },
            excluded_filetypes = {
                'dropbar_menu',
                'noice',
                'ssr',
                'ssr_confirm',
            },
        },
    },
}

