return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            sources = {
                'filesystem',
                'buffers',
                'git_status',
                'document_symbols',
            },
            auto_clean_after_session_restore = true,
            close_if_last_window = true,
            default_source = 'last',
            popup_border_style = 'rounded',
            source_selector = {
                winbar = true,
                sources = {
                    { source = 'filesystem' },
                    { source = 'buffers' },
                    { source = 'git_status' },
                    { source = 'document_symbols' },
                },
            },
        },
    },
}
