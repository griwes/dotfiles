return {
    {
        'TaDaa/vimade',
        init = function()
            vim.api.nvim_create_autocmd('CursorHold', {
                callback = function()
                    -- Neovide under i3 can miss FocusGained after workspace switches.
                    vim.g.vimade_paused = 0
                end,
            })
        end,
        opts = {
            recipe = {
                'duo',
                {
                    animate = true,
                },
            },
            fadelevel = 0.95,
            blocklist = {
                custom = {
                    highlights = {
                        '/^lualine.*/',
                    },
                    buf_opts = {
                        buftype = {
                            'terminal',
                        },
                        filetype = {
                            'codediff-explorer',
                            'dap',
                            'noice',
                            'qf',
                            'trouble',
                        },
                    },
                    win_opts = {
                        'diff',
                    },
                    win_vars = {
                        codediff_restore = 1,
                    },
                },
            },
            groupdiff = true,
            groupscrollbind = true,
        },
    },
}
