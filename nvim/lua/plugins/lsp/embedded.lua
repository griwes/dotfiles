return {
    -- TODO: this doesn't seem to work for me at all, diagnose what the problem is later
    {
        'jmbuhr/otter.nvim',
        dependencies = {
            -- 'hrsh7th/nvim-cmp',
            'neovim/nvim-lspconfig',
            'nvim-treesitter/nvim-treesitter'
        },
        event = 'BufEnter',
        opts = {
            buffers = {
                set_filetype = true,
                write_to_disk = true,
            },
            strip_wrapping_quote_characters = { '"', "'", '`' },
        },
        config = function(_, opts)
            local otter = require('otter')
            otter.setup(opts)

            vim.api.nvim_create_augroup('Otter', { clear = true })
            --[[ vim.api.nvim_create_autocmd('BufEnter', {
                pattern = '*',
                group = 'Otter',
                callback = function()
                    otter.activate({
                        'lua',
                        'vim',
                        'c',
                        'c++',
                        'cuda',
                        'python',
                        'bash',
                    })
                end
            }) ]]
        end,
    },
}
