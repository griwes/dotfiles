local function spider_motion(key)
    return function()
        require('spider').motion(key)
    end
end

return {
    {
        'chrisgrieser/nvim-spider',
        event = 'VeryLazy',
        opts = {
            skipInsignificantPunctuation = false,
        },
        config = function(_, opts)
            require('spider').setup(opts)
        end,
        keys = {
            { 'w', spider_motion('w'), mode = { 'n', 'v' }, desc = '󰛔 Spider word forward' },
            { 'e', spider_motion('e'), mode = { 'n', 'v' }, desc = '󰛔 Spider word end' },
            { 'b', spider_motion('b'), mode = { 'n', 'v' }, desc = '󰛔 Spider word backward' },
            { 'ge', spider_motion('ge'), mode = { 'n', 'v' }, desc = '󰛔 Spider previous word end' },
        },
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        init = function()
            vim.cmd([[
                highlight! FlashMatch guifg=#f6b079 guibg=None gui=bold
                highlight! FlashLabel guifg=#7ad5d6 guibg=None gui=bold
            ]])
        end,
        opts = {
            label = {
                uppercase = false,
            },
            modes = {
                search = {
                    highlight = {
                        backdrop = true,
                    },
                    search = {
                        multi_window = false,
                        incremental = true,
                    },
                },
                char = {
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                'gw',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump({
                        search = {
                            mode = function(pattern)
                                -- remove leading dot
                                if pattern:sub(1, 1) == '.' then
                                    pattern = pattern:sub(2)
                                end
                                -- return word pattern and proper skip pattern
                                return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
                            end,
                        },
                        label = {
                            after = false,
                            before = true,
                        },
                    })
                end,
                desc = '󰛔 Flash word jump',
            },
            {
                'g/',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = '󰛔 Flash search',
            },
            {
                'g?',
                mode = { 'o', 'x' },
                function()
                    require('flash').treesitter_search()
                end,
                desc = '󰐅 Flash treesitter search',
            },
            {
                'gr',
                mode = { 'o' },
                function()
                    require('flash').remote()
                end,
                desc = '󰛔 Remote Flash',
            },
        },
    },
}
