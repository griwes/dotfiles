return {
    {
        'mbbill/undotree',
        lazy = false,
        keys = {
            { '<leader>ut', '<cmd>UndotreeToggle<cr>' },
            { '<leader>uf', '<cmd>UndotreeFocus<cr>' },
        }
    },
    {
        'kevinhwang91/nvim-fundo',
        dependencies = {
            'kevinhwang91/promise-async',
        },
        event = 'VeryLazy',
        config = function()
            local fundo = require('fundo')

            fundo.install()
            fundo.setup()
        end,
    },
}
