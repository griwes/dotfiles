return {
    {
        'nvimtools/none-ls.nvim',
        ft = {
            'gitcommit',
            'yaml',
        },
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        opts = function()
            local null_ls = require('null-ls')

            return {
                border = 'rounded',
                -- Keep none-ls narrow: it exposes external diagnostics to
                -- Neovim, while Mason Tool Installer owns these editor-invoked
                -- lint binaries.
                sources = {
                    null_ls.builtins.diagnostics.actionlint,
                    null_ls.builtins.diagnostics.commitlint,
                    null_ls.builtins.diagnostics.gitlint,
                },
            }
        end,
        config = function(_, opts)
            require('null-ls').setup(opts)
        end,
    },
}
