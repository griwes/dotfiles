return {
    {
        'MunifTanjim/nui.nvim'
    },
    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        config = function()
            require('notify').setup({
                background_colour = '#000000'
            })
            vim.notify = require('notify')
        end
    },
    {
        -- TODO: configure keybinds?
        'stevearc/dressing.nvim'
    },
    {
        'mrjones2014/smart-splits.nvim',
        event = 'VeryLazy',
        config = function()
            require('smart-splits').setup({
                resize_mode = {
                    hooks = {
                        on_leave = require('bufresize').register,
                    },
                },
                multiplexer_integration = false,
            })
        end
    },
    {
        'kwkarlwang/bufresize.nvim',
        event = 'VeryLazy',
        config = function()
            require('bufresize').setup({})
        end
    },
    {
        'stevearc/stickybuf.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {
        },
    },
    -- TODO: move the undo things into their own config
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
    }
}
