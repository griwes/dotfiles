local scissors_path = vim.fn.stdpath('config') .. '/snippets'

return {
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'chrisgrieser/nvim-scissors',
            'rafamadriz/friendly-snippets',
        },
        build = 'make install_jsregexp',
        opts = {
            keep_roots = true,
            link_roots = true,
            link_children = true,
            store_selection_keys = '<Tab>',
        },
        config = function(_, opts)
            local luasnip = require('luasnip')

            luasnip.config.setup(opts)

            require('luasnip.loaders.from_vscode').lazy_load({
                paths = {
                    scissors_path,
                    vim.fn.stdpath('data') .. '/lazy/friendly-snippets',
                },
            })
        end,
    },
    {
        'chrisgrieser/nvim-scissors',
        opts = {
            snippetDir = scissors_path,
        },
        keys = {
            {
                'hSc',
                function()
                    require('scissors').addNewSnippet()
                end,
                desc = ' Create a new snippet',
                mode = { 'n', 'x' },
            },
            {
                'hSe',
                function()
                    require('scissors').editSnippet()
                end,
                desc = ' Edit a snippet',
            },
        },
    },
}
