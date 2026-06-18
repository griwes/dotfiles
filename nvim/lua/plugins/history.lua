return {
    {
        'y3owk1n/time-machine.nvim',
        opts = {
            diff_tool = 'difft',
        },
        cmd = {
            'TimeMachineToggle',
            'TimeMachinePurgeBuffer',
            'TimeMachinePurgeAll',
            'TimeMachineLogShow',
            'TimeMachineLogClear',
        },
        keys = {
            {
                'hu',
                function()
                    require('time-machine').actions.toggle()
                end,
                desc = '󰋚 Open undo history',
            },
        },
    },
}
