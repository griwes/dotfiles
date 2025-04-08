return {
    {
        "MunifTanjim/nui.nvim",
    },
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        config = function()
            require("notify").setup({
                background_colour = "#000000",
                render = "wrapped-compact",
                stages = "fade",
                top_down = false,
            })
            vim.notify = require("notify")
        end,
    },
    {
        -- TODO: configure keybinds?
        "stevearc/dressing.nvim",
    },
    {
        "mrjones2014/smart-splits.nvim",
        event = "VeryLazy",
        config = function()
            require("smart-splits").setup({
                resize_mode = {
                    hooks = {
                        on_leave = require("bufresize").register,
                    },
                },
                multiplexer_integration = false,
            })
        end,
    },
    {
        "kwkarlwang/bufresize.nvim",
        event = "VeryLazy",
        config = function()
            require("bufresize").setup({})
        end,
    },
    {
        "stevearc/stickybuf.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "tomiis4/Hypersonic.nvim",
        event = "CmdlineEnter",
        opts = {
            winblend = 75,
        },
        cmd = "Hypersonic",
        keys = {},
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
            code = {
                style = 'normal',
                position = 'right',
            },
            overrides = {
                filetype = {},
            },
        },
    },
    {
        'SCJangra/table-nvim',
        ft = 'markdown',
        opts = {
            mappings = {                             -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
                next = '<TAB>',                      -- Go to next cell.
                prev = '<S-TAB>',                    -- Go to previous cell.
                insert_row_up = '<leader>mtl',       -- Insert a row above the current row.
                insert_row_down = '<leader>mtk',     -- Insert a row below the current row.
                move_row_up = '<leader>mtL',         -- Move the current row up.
                move_row_down = '<leader>mtK',       -- Move the current row down.
                insert_column_left = '<leader>mtj',  -- Insert a column to the left of current column.
                insert_column_right = '<leader>mt;', -- Insert a column to the right of current column.
                move_column_left = '<leader>mtJ',    -- Move the current column to the left.
                move_column_right = '<leader>mt:',   -- Move the current column to the right.
                insert_table = '<leader>mtn',        -- Insert a new table.
                insert_table_alt = '<leader>mtan',   -- Insert a new table that is not surrounded by pipes.
                delete_column = '<leader>mtd',       -- Delete the column under cursor.
            }
        },
    },
    {
        -- TODO: some keymaps for toggling
        -- TODO: statusline component
        "NStefan002/screenkey.nvim",
        branch = 'dev',
        cmds = 'Screenkey',
    },
}
