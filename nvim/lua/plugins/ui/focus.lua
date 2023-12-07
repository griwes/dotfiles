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
            { '<leader>z', '<cmd>NeoZoomToggle<cr>', desc = 'Toggle zoom on current buffer' },
        }
    },
    {
        'anuvyklack/windows.nvim',
        dependencies = {
            'anuvyklack/middleclass',
            'anuvyklack/animation.nvim'
        },
        config = function()
            vim.o.winwidth = 15
            vim.o.winminwidth = 15
            vim.o.equalalways = false
            vim.o.textwidth = 120
            require('windows').setup({
                autowidth = {
                    winwidth = 1.1,
                },
                ignore = {
                    buftype = {
                        'terminal'
                    },
                    filetype = {
                        'DiffviewFiles',
                        'DiffviewFileHistory',
                    }
                },
                animation = {
                    fps = 30,
                    duration = 200,
                }
            })
        end
    },
}
