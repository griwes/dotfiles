return {
    {
        'anuvyklack/windows.nvim',
        dependencies = {
            'anuvyklack/middleclass',
            'anuvyklack/animation.nvim',
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
                        'terminal',
                    },
                    filetype = {
                        'codediff-explorer',
                        'snacks_picker_list',
                        'snacks_picker_input',
                        'snacks_picker_preview',
                        'snacks_layout_box',
                    },
                },
                animation = {
                    fps = 1,
                    duration = 200,
                },
            })
        end,
    },
}
