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

            local util = require('luasnip.nodes.util')
            local types = require('luasnip.util.types')
            local orig = util.subsnip_init_children
            util.subsnip_init_children = function(parent, children)
                orig(parent, children)

                for _, node in ipairs(children) do
                    if node.type == types.exitNode then
                        if #parent.env.LS_SELECT_RAW ~= 0 then
                            node.static_text = parent.env.LS_SELECT_RAW
                            node.static_text[1] = string.match(node.static_text[1], '^%s*(.-)%s*$')
                        end
                        return
                    end
                end
            end

            require('luasnip.loaders.from_vscode').lazy_load({
                paths = {
                    scissors_path,
                    vim.fn.stdpath('data') .. '/lazy/friendly-snippets',
                }
            })
        end,
    },
    {
        'L3MON4D3/cmp-luasnip-choice',
        opts = {
            auto_open = true,
        },
    },
    {
        'chrisgrieser/nvim-scissors',
        dependencies = {
            'telescope/telescope.nvim',
        },
        opts = {
            snippetDir = scissors_path,
            jsonFormatter = 'jq',
        },
        keys = {
            { '<leader>csc', function() require('scissors').addNewSnippet() end, desc = 'Create a new snippet', mode = { 'n', 'x' } },
            { '<leader>cse', function() require('scissors').editSnippet() end, desc = 'Edit a snippet' },
        },
    },
}
