return {
    {
        'akinsho/git-conflict.nvim',
        event = 'VeryLazy',
        opts = {
            disable_diagnostics = false,
        },
    },
    {
        'linrongbin16/gitlinker.nvim',
        event = 'VeryLazy',
        opts = {},
        keys = {
            { '<leader>glr', '<cmd>GitLink browse<cr>', desc = 'Copy a link to the current line in a remote' },
            {
                '<leader>gll',
                '<cmd>GitLink blame<cr>',
                desc = 'Copy a link to the blame of the current line in a remote',
            },
        },
    },
    {
        'FabijanZulj/blame.nvim',
        opts = {
            merge_consecutive = true,
        },
        cmds = {
            'ToggleBlame',
            'EnableBlame',
            'DisableBlame',
        },
        keys = {
            { '<leader>gsf', '<cmd>ToggleBlame virtual<cr>', 'Toggle full buffer blame' },
        },
    },
}
