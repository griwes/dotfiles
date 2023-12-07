return {
    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        opts = {
            numhl = true,
            signcolumn = true,
            attach_to_untracked = false,
            preview_config = {
                border = 'rounded',
            },
        },
        cmd = 'Gitsigns',
        keys = {
            { '<leader>gsb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle current line blame' },
        }
    },
    {
        -- TODO: configure
        'sindrets/diffview.nvim',
        lazy = false,
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        opts = {
        },
    },
    {
        "NeogitOrg/neogit",
        branch = 'nightly',
        event = 'VeryLazy',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            "sindrets/diffview.nvim",
        },
        opts = {
            disable_hint = true,
            graph_style = 'unicode',
            integrations = {
                telescope = true,
                diffview = true,
                fzf = false,
            },
            mappings = {
                popup = {
                    ['l'] = false,
                    ['L'] = 'LogPopup',
                },
            },
            telescope_sorter = function(opts)
                return require('telescope.sorters').get_fzy_sorter(opts)
            end,
        },
        init = function()
            local mod = require('neogit.lib.finder')
            local orig = mod.new
            ---@diagnostic disable-next-line: duplicate-set-field
            mod.new = function(opts)
                local ret = orig(mod, opts)
                ret.opts = {
                }
                return ret
            end
        end,
    },
    {
        'akinsho/git-conflict.nvim',
        event = 'VeryLazy',
        opts = {
            disable_diagnostics = true,
        },
    },
    {
        'linrongbin16/gitlinker.nvim',
        event = 'VeryLazy',
        opts = {
        },
        keys = {
            { '<leader>glr', '<cmd>GitLink browse<cr>', desc = 'Copy a link to the current line in a remote' },
            { '<leader>gll', '<cmd>GitLink blame<cr>',  desc = 'Copy a link to the blame of the current line in a remote' },
        },
    },
}
