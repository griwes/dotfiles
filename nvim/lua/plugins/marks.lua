return {
    {
        -- TODO: configure bookmark groups to give them some sort of meaning?
        'chentoast/marks.nvim',
        event = 'VeryLazy',
        opts = {
            builtin_marks = { '.', '<', '>', '^' },
            force_write_shada = true,
            excluded_buftypes = {
                'nofile',
                'prompt',
                'terminal',
            },
            excluded_filetypes = {
                'noice',
                'ssr',
                'ssr_confirm',
            },
        },
    },
}

