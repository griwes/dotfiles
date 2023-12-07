return {
    {
        'folke/trouble.nvim',
        opts = {
            position = 'right',
            auto_open = false,
            auto_close = true,
            use_diagnostic_signs = true,
        },
        cmd = {
            'TroubleOpen',
            'TroubleClose',
            'TroubleToggle',
        },
        keys = {
            { '<leader>tw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
                desc = 'Toggle Trouble workspace dignostics' },
            { '<leader>td', '<cmd>TroubleToggle document_diagnostics<cr>',
                desc = 'Toggle Trouble document dignostics' },
            { '<leader>tq', '<cmd>TroubleToggle quickfix<cr>', desc = 'Toggle Trouble quickfix' },
            { '<leader>tt', '<cmd>TroubleToggle<cr>', desc = 'Toggle Trouble' }
        }
    },
}
