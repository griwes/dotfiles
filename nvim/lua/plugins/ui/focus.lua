return {
    {
        'nyngwang/NeoZoom.lua',
        opts = {
            popup = {
                enabled = true,
            },
            winopts = {
                offset = {
                    width = 200,
                    height = 0.9
                },
                border = 'rounded'
            },
            callbacks = {
                function()
                    vim.cmd([[
                        hi NeoZoomFloatBg guibg=None
                        set winhl=Normal:NeoZoomFloatBg
                    ]])
                end,
            },
        },
        cmd = 'NeoZoomToggle',
        keys = {
            { '<leader>zz', '<cmd>NeoZoomToggle<cr>', desc = 'Toggle zoom on current buffer' },
        }
    },
    {
        'folke/twilight.nvim',
        opts = {
            dimming = {
                inactive = true,
            },
        },
        cmds = {
            'Twilight',
            'TwilightEnable',
            'TwilightDisable',
        },
        keys = {
            { '<leader>zf', '<cmd>Twilight<cr>', desc = 'Toggle highlight of only nearby code' },
        }
    },
    {
        'nvim-zh/colorful-winsep.nvim',
        event = 'WinNew',
        config = true,
    },
}
