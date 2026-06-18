return {
    'stevearc/overseer.nvim',
    opts = {
        strategy = 'terminal',
        templates = {
            'builtin',
        },
        task_list = {
            direction = 'right',
            bindings = {
                ['?'] = 'ShowHelp',
                ['g?'] = 'ShowHelp',
                ['<CR>'] = 'RunAction',
                ['<C-e>'] = 'Edit',
                ['o'] = 'Open',
                ['<C-v>'] = 'OpenVsplit',
                ['<C-s>'] = 'OpenSplit',
                ['<C-f>'] = 'OpenFloat',
                ['<C-q>'] = 'OpenQuickFix',
                ['p'] = 'TogglePreview',
                ['<C-;>'] = 'IncreaseDetail',
                ['<C-j>'] = 'DecreaseDetail',
                ['L'] = 'IncreaseAllDetail',
                ['J'] = 'DecreaseAllDetail',
                ['['] = 'DecreaseWidth',
                [']'] = 'IncreaseWidth',
                ['{'] = 'PrevTask',
                ['}'] = 'NextTask',
                ['<C-l>'] = 'ScrollOutputUp',
                ['<C-k>'] = 'ScrollOutputDown',
                ['q'] = 'Close',
            },
        },
    },
    keys = {
        {
            'hOr',
            function()
                require('overseer').run_task({})
            end,
            desc = '󰐊 Run task',
        },
        {
            'hOt',
            function()
                require('overseer').toggle()
            end,
            desc = '󰐊 Toggle task list',
        },
    },
}
