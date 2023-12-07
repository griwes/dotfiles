return {
    {
        'EtiamNullam/deferred-clipboard.nvim',
        event = 'VeryLazy',
        opts = {
            fallback = 'unnamedplus',
            lazy = true,
        },
    },
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {
            'kkharji/sqlite.lua'
        },
        event = 'VeryLazy',
        opts = {
            history = 16384,
            enable_persistent_history = true,
            continuous_sync = true,
            content_spec_column = true,
        },
    }
}
