local csv_icon = ' '

local function enable_csvview(opts)
    return function()
        local csvview = require('csvview')
        if csvview.is_enabled(0) then
            csvview.disable(0)
        end
        csvview.enable(0, opts)
    end
end

return {
    {
        'hat0uma/csvview.nvim',
        cmd = {
            'CsvViewDisable',
            'CsvViewEnable',
            'CsvViewInfo',
            'CsvViewToggle',
        },
        keys = {
            {
                'hTt',
                function()
                    require('csvview').toggle(0)
                end,
                desc = csv_icon .. 'Toggle CSV view',
            },
            {
                'hTb',
                enable_csvview({
                    view = {
                        display_mode = 'border',
                    },
                }),
                desc = csv_icon .. 'Use CSV border view',
            },
            {
                'hTh',
                enable_csvview({
                    view = {
                        display_mode = 'highlight',
                    },
                }),
                desc = csv_icon .. 'Use CSV highlight view',
            },
            {
                'hTi',
                function()
                    require('csvview').info(0)
                end,
                desc = csv_icon .. 'Show CSV view info',
            },
            {
                'hTd',
                function()
                    require('csvview').disable(0)
                end,
                desc = csv_icon .. 'Disable CSV view',
            },
        },
        opts = {
            view = {
                display_mode = 'border',
                spacing = {
                    left = 1,
                    right = 1,
                },
            },
            keymaps = {
                textobject_field_inner = {
                    'if',
                    mode = { 'o', 'x' },
                    desc = csv_icon .. 'Select inside CSV field',
                },
                textobject_field_outer = {
                    'af',
                    mode = { 'o', 'x' },
                    desc = csv_icon .. 'Select around CSV field',
                },
                jump_next_field_start = {
                    ']f',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Next CSV field',
                },
                jump_prev_field_start = {
                    '[f',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Previous CSV field',
                },
                jump_next_field_end = {
                    ']F',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Next CSV field end',
                },
                jump_prev_field_end = {
                    '[F',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Previous CSV field end',
                },
                jump_next_row = {
                    ']r',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Next CSV row',
                },
                jump_prev_row = {
                    '[r',
                    mode = { 'n', 'x', 'o' },
                    desc = csv_icon .. 'Previous CSV row',
                },
            },
        },
    },
}
