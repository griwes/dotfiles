return {
    {
        'MunifTanjim/nui.nvim',
    },
    {
        'rcarriga/nvim-notify',
        event = 'VeryLazy',
        config = function()
            require('notify').setup({
                background_colour = '#000000',
                render = 'wrapped-compact',
                stages = 'fade',
                top_down = false,
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
        'NvChad/nvim-colorizer.lua',
        event = 'VeryLazy',
        opts = {
            user_default_options = {
                mode = 'virtualtext',
            }
        }
    },
    {
        'tomiis4/Hypersonic.nvim',
        event = 'CmdlineEnter',
        opts = {
            winblend = 75,
        },
        cmd = 'Hypersonic',
        keys = {
        },
    },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
        ft = { 'markdown' },
        build = function() vim.fn['mkdp#util#install']() end,
    },
    {
        'MeanderingProgrammer/markdown.nvim',
        opts = {
        },
    },
}
