return {
    {
        -- TODO: actually configure things like scopes
        -- configure a way to create named grapples
        'cbochs/grapple.nvim',
        event = 'VeryLazy',
        init = function()
            local tag_actions = require('grapple.tag_actions')

            ---@diagnostic disable-next-line: duplicate-set-field
            function tag_actions.select(opts)
                require("grapple").select({
                    path = opts.path,
                    name = opts.name,
                    index = opts.index,
                    scope = opts.scope.name,
                    command = opts.command or vim.cmd.drop,
                })
            end
        end,
        opts = {
            scope = 'git_branch',
            popup_options = {
                border = 'rounded',
            },
        },
        keys = {
            { '<leader>jt', '<cmd>Grapple tag<cr>' },
            { '<leader>ju', '<cmd>Grapple untag<cr>' },
            { '<leader>jot', '<cmd>Grapple open_tags<cr>' },
            { '<leader>jos', '<cmd>Grapple open_scopes<cr>' },
            { '<leader>jf', '<cmd>Telescope grapple tags<cr>' },
        },
    },
}
