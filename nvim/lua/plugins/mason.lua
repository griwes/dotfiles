return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        priority = 900,
        config = function()
            require('mason').setup()
        end
    },
}
