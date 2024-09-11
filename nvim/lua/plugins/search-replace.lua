return {
    {
        'AckslD/muren.nvim',
        opts = {
            two_step = true,
            patterns_width = 120,
            patterns_height = 15,
            options_width = 50,
            preview_height = 45,
        },
        cmds = {
            'MurenToggle',
            'MurenOpen',
            'MurenClose',
            'MurenFresh',
            'MurenUnique',
        },
        keys = {
            { '<leader>rm', '<cmd>MurenToggle<cr>', desc = 'Open Muren window' },
            { '<leader>ru', '<cmd>MurenUnique<cr>', desc = 'Open MurenUnique window' },
        }
    },
    {
        'MagicDuck/grug-far.nvim',
        opts = {
            maxWorkers = 8,
            windowCreationCommand = 'tabnew %',
            keymaps = {
                replace = { n = '<leader>rr' },
                qflist = { n = '<leader>q' },
                syncLocations = { n = '<leader>s' },
                syncLine = { n = '<leader>l' },
                close = { n = '<leader>c' },
                historyOpen = { n = '<leader>t' },
                historyAdd = { n = '<leader>a' },
                refresh = { n = '<leader>f' },
                openLocation = { n = '<leader>o' },
                gotoLocation = { n = '<enter>' },
                pickHistoryEntry = { n = '<enter>' },
                abort = { n = '<leader>b' },
            },
        },
        keys = {
            {
                '<leader>rg',
                function()
                    require('grug-far').grug_far()
                end,
                desc = 'Open Grug'
            },
        },
    },
    {
        'cshuaimin/ssr.nvim',
        opts = {
            max_width = 180,
            max_height = 60,
            keymaps = {
                replace_all = '<S-cr>',
            },
        },
        keys = {
            { '<leader>rr', function() require('ssr').open() end, desc = 'Open structural replace', mode = { 'n', 'x' } },
        },
    },
    {
        'chrisgrieser/nvim-rip-substitute',
        opts = {
            popupWin = {
                border = 'rounded',
            },
            incrementalPreview = {
                rangeBackdrop = {
                    blend = 80,
                },
            },
        },
        cmd = 'RipSubstitute',
        keys = {
            {
                '<leader>%s',
                function()
                    local win = vim.api.nvim_get_current_win()
                    require('rip-substitute').sub()
                    require('tint').untint(win)
                end,
                mode = { 'n', 'x' },
                desc = ' rip substitute',
            },
        },
    },
}
