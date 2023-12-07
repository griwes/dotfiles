return {
    {
        'jay-babu/mason-nvim-dap.nvim',
        event = 'VeryLazy',
        dependencies = {
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'codelldb',
                'bash',
                'python',
            },
            handlers = {
                function(config) 
                    require('mason-nvim-dap').default_setup(config)
                end,
                codelldb = require('plugins.dap.debug.codelldb'),
            },
        },
    },
    {
        'mfussenegger/nvim-dap',
        event = 'VeryLazy',
        dependencies = {
            'jay-babu/mason-nvim-dap.nvim',
        },
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        event = 'VeryLazy',
        opts = {
        },
    },
}
