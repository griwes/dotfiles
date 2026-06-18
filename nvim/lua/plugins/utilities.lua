local function various_textobj(name, ...)
    local args = { ... }

    return function()
        require('various-textobjs')[name](unpack(args))
    end
end

return {
    {
        'krady21/compiler-explorer.nvim',
        event = 'VeryLazy',
        opts = {
            autocmd = {
                enable = true,
            },
            diagnostics = {
                virtual_text = true,
            },
        },
    },
    {
        'stevearc/oil.nvim',
        dependencies = {
            'JezerM/oil-lsp-diagnostics.nvim',
            'malewicz1337/oil-git.nvim',
        },
        opts = {
            constrain_cursor = 'editable',
            columns = {
                {
                    'permissions',
                    highlight = function(permission_str)
                        local permission_hlgroups = {
                            ['-'] = 'NonText',
                            ['r'] = 'DiagnosticSignWarn',
                            ['w'] = 'DiagnosticSignError',
                            ['x'] = 'DiagnosticSignOk',
                            ['t'] = 'DiagnosticSignInfo',
                        }

                        local hls = {}
                        for i = 1, #permission_str do
                            local char = permission_str:sub(i, i)
                            table.insert(hls, { permission_hlgroups[char], i - 1, i })
                        end
                        return hls
                    end,
                },
                { 'size', highlight = 'Number' },
                { 'mtime', highlight = 'Special' },
                { 'icon' },
            },
            win_options = {
                number = false,
                relativenumber = false,
                signcolumn = 'no',
                foldcolumn = '0',
                statuscolumn = '',
            },
        },
        cmd = { 'Oil' },
        keys = {
            {
                'g-',
                function()
                    require('oil').open()
                end,
                desc = '󰉋 Open Oil',
            },
        },
        config = function(_, opts)
            require('oil').setup(opts)
            require('oil-lsp-diagnostics').setup({})
            require('oil-git').setup({})
        end,
    },
    {
        'nacro90/numb.nvim',
        event = 'VeryLazy',
        opts = {
            number_only = true,
        },
    },
    {
        'chrisgrieser/nvim-various-textobjs',
        event = 'VeryLazy',
        opts = {
            keymaps = {
                useDefaults = false,
            },
        },
        keys = {
            {
                'ii',
                various_textobj('indentation', 'inner', 'inner'),
                desc = '󰉶 Select inside indentation',
                mode = { 'o', 'x' },
            },
            {
                'ai',
                various_textobj('indentation', 'outer', 'inner'),
                desc = '󰉶 Select around indentation',
                mode = { 'o', 'x' },
            },
            {
                'aI',
                various_textobj('indentation', 'outer', 'outer'),
                desc = '󰉶 Select around indentation with blanks',
                mode = { 'o', 'x' },
            },
            { 'iS', various_textobj('subword', 'inner'), desc = '󰘦 Select inside subword', mode = { 'o', 'x' } },
            { 'aS', various_textobj('subword', 'outer'), desc = '󰘦 Select around subword', mode = { 'o', 'x' } },
            { 'ik', various_textobj('key', 'inner'), desc = '󰌋 Select inside key', mode = { 'o', 'x' } },
            { 'ak', various_textobj('key', 'outer'), desc = '󰌋 Select around key', mode = { 'o', 'x' } },
            { 'iv', various_textobj('value', 'inner'), desc = '󰎠 Select inside value', mode = { 'o', 'x' } },
            { 'av', various_textobj('value', 'outer'), desc = '󰎠 Select around value', mode = { 'o', 'x' } },
            { 'iF', various_textobj('filepath', 'inner'), desc = '󰈔 Select inside filepath', mode = { 'o', 'x' } },
            { 'aF', various_textobj('filepath', 'outer'), desc = '󰈔 Select around filepath', mode = { 'o', 'x' } },
            {
                'im',
                various_textobj('chainMember', 'inner'),
                desc = '󰫢 Select inside chain member',
                mode = { 'o', 'x' },
            },
            {
                'am',
                various_textobj('chainMember', 'outer'),
                desc = '󰫢 Select around chain member',
                mode = { 'o', 'x' },
            },
        },
    },
    {
        -- TODO: learn
        'kylechui/nvim-surround',
        event = 'VeryLazy',
        opts = {
            move_cursor = 'sticky',
        },
        keys = {
            { 'ir', 'i[', desc = '󰅪 Select inside square brackets', mode = 'o' },
            { 'ar', 'a[', desc = '󰅪 Select around square brackets', mode = 'o' },
            { 'ia', 'i<', desc = '󰅪 Select inside angle brackets', mode = 'o' },
            { 'aa', 'a<', desc = '󰅪 Select around angle brackets', mode = 'o' },
        },
    },
    {
        -- TODO: learn
        'gbprod/substitute.nvim',
        event = 'VeryLazy',
        opts = {
            on_substitute = function()
                require('yanky.integration').substitute()
            end,
        },
        keys = {
            {
                's',
                function()
                    require('substitute').operator()
                end,
                desc = ' Substitute motion with register',
            },
            {
                'ss',
                function()
                    require('substitute').line()
                end,
                desc = ' Substitute line with register',
            },
            {
                'S',
                function()
                    require('substitute').eol()
                end,
                desc = ' Substitute to end of line',
            },
            {
                's',
                function()
                    require('substitute').visual()
                end,
                mode = 'x',
                desc = ' Substitute selection with register',
            },

            {
                'sx',
                function()
                    require('substitute.exchange').operator()
                end,
                desc = '󰓡 Exchange motion with later text',
            },
            {
                'sxx',
                function()
                    require('substitute.exchange').line()
                end,
                desc = '󰓡 Exchange current line with later line',
            },
            {
                'X',
                function()
                    require('substitute.exchange').visual()
                end,
                mode = 'x',
                desc = '󰓡 Exchange selection with later text',
            },
            {
                'sxc',
                function()
                    require('substitute.exchange').cancel()
                end,
                desc = '󰓡 Cancel pending exchange',
            },

            {
                '<M-s>',
                function()
                    require('substitute.range').operator()
                end,
                desc = ' Substitute over explicit range',
            },
            {
                '<M-s>',
                function()
                    require('substitute.range').visual()
                end,
                mode = 'x',
                desc = ' Substitute selected range',
            },
            {
                '<M-s>w',
                function()
                    require('substitute.range').word()
                end,
                desc = ' Substitute word over range',
            },
        },
    },
    {
        'axieax/typo.nvim',
        event = 'VeryLazy',
        opts = {},
    },
    {
        'abecodes/tabout.nvim',
        event = 'InsertCharPre',
        opts = {
            tabkey = '',
            backwards_tabkey = '',
            completion = false,
        },
    },
}
