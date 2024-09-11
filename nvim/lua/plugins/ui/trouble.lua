return {
    {
        'folke/trouble.nvim',
        --branch = 'dev',
        opts = {
            auto_preview = false,
            auto_jump = false,
            max_items = 500,
            multiline = false,

            keys = {
                j = 'fold_close',
                k = 'next',
                l = 'prev',
                [';'] = 'fold_open',
            },
            preview = {
                type = 'split',
                relative = 'win',
                position = 'right',
                size = 0.6,
            },
            icons = {
                indent = {
                    last = '╰╴',
                },
            },
            modes = {
                lsp_definitions = {
                    auto_jump = false,
                },
                lsp_references = {
                    auto_jump = false,
                },
                lsp_type_definitions = {
                    auto_jump = false,
                },
                lsp_implementations = {
                    auto_jump = false,
                },
                lsp_declarations = {
                    auto_jump = false,
                },
                quickfix = {
                    groups = {
                        { 'directory' },
                        { 'filename', format = '{file_icon} {basename} {count}' },
                    },
                },
            },
        },
    },
    {
        'folke/todo-comments.nvim',
        lazy = false,
        opts = {
            highlight = {
                pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
            },
            search = {
                 pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
            },
        },
        keys = {
            -- TODO: reconfigure these in nap.nvim
            {
                ']t',
                function()
                    require('todo-comments').jump_next()
                end,
                desc = 'Next todo comment',
            },
            {
                '[t',
                function()
                    require('todo-comments').jump_prev()
                end,
                desc = 'Previous todo comment',
            },
        },
    },
}
