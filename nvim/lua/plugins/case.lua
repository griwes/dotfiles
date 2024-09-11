return {
    {
        'johmsalas/text-case.nvim',
        opts = {
        },
        keys = {
            'ga',
            { 'ga.', '<cmd>TextCaseOpenTelescope<CR>', mode = { 'n', 'x' }, desc = 'Telescope' },
        },
        cmd = {
            'Subs',
            'TextCaseOpenTelescopeQuickChange',
            'TextCaseOpenTelescopeLSPChange',
            'TextCaseStartReplacingCommand',
        },
    },
}
