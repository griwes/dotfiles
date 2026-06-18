return {
    {
        'folke/lazydev.nvim',
        ft = 'lua',
        -- Lazydev owns LuaLS workspace/library policy. Blink's lazydev
        -- provider only exposes that policy through completion UI.
        opts = {
            library = {
                { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
            },
            enabled = function()
                return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
            end,
        },
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'mason-org/mason-lspconfig.nvim',
        },
        init = function()
            require('config.lsp')
        end,
    },
}
