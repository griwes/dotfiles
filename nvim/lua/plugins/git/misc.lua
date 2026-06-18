return {
    {
        'FabijanZulj/blame.nvim',
        opts = {
            merge_consecutive = true,
        },
        cmd = {
            'BlameToggle',
        },
        keys = {
            { 'hGB', '<cmd>BlameToggle virtual<cr>', desc = ' Toggle full buffer blame' },
        },
    },
}
