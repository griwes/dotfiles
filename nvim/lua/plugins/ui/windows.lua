return {
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
                        'blame',
                    }
                },
                animation = {
                    fps = 1,
                    duration = 200,
                }
            })
        end
    },
    {
        'sindrets/winshift.nvim',
        opts = {
            keymaps = {
                disable_defaults = false,
                win_move_mode = {
                    ['j'] = 'left',
                    ['k'] = 'down',
                    ['l'] = 'up',
                    [';'] = 'right',
                    ['J'] = 'far_left',
                    ['K'] = 'far_down',
                    ['L'] = 'far_up',
                    [':'] = 'far_right',
                    ['<left>'] = 'left',
                    ['<down>'] = 'down',
                    ['<up>'] = 'up',
                    ['<right>'] = 'right',
                    ['<S-left>'] = 'far_left',
                    ['<S-down>'] = 'far_down',
                    ['<S-up>'] = 'far_up',
                    ['<S-right>'] = 'far_right',
                },
            },
        },
        cmd = 'WinShift',
        keys = {
            { '<C-w>m',       '<cmd>WinShift<cr>' },
            { '<C-w>x',       '<cmd>WinShift swap<cr>' },

            { '<C-w><C-j>',   '<cmd>WinShift left<cr>' },
            { '<C-w><C-S-j>', '<cmd>WinShift far_left<cr>' },
            { '<C-w><C-k>',   '<cmd>WinShift down<cr>' },
            { '<C-w><C-S-k>', '<cmd>WinShift far_down<cr>' },
            { '<C-w><C-l>',   '<cmd>WinShift up<cr>' },
            { '<C-w><C-S-l>', '<cmd>WinShift far_up<cr>' },
            { '<C-w><C-;>',   '<cmd>WinShift right<cr>' },
            { '<C-w><C-S-;>', '<cmd>WinShift far_right<cr>' },
        }
    }
}
