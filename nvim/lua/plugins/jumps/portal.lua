return {
    {
        'cbochs/portal.nvim',
        dependencies = {
            'cbochs/grapple.nvim',
        },
        init = function()
            local pw = require('portal.window')

            local orig = pw.new

            ---@diagnostic disable-next-line: duplicate-set-field
            function pw:new(label, content, window_options)
                window_options.title = ('[%s] %s'):format(content.type, vim.api.nvim_buf_get_name(content.buffer))
                return orig(pw, label, content, window_options)
            end
        end,
        opts = {
            labels = { 'j', 'k', 'l', ';', 'm', ',', '.', '/', },
            window_options = {
                border = 'rounded',
                width = 120,
                height = 5,
            },
        },
        cmds = {
            'Portal',
        },
        keys = {
            { 'gjj', '<cmd>Portal jumplist backward<cr>' },
            { 'gj;', '<cmd>Portal jumplist forward<cr>' },
            { 'gjk', '<cmd>Portal grapple backward<cr>' },
            { 'gjl', '<cmd>Portal grapple forward<cr>' },
            { 'gjx', '<cmd>Portal changelist backward<cr>' },
            { 'gjc', '<cmd>Portal changelist forward<cr>' },
            { 'gjq', '<cmd>Portal quickfix backward<cr>' },
            { 'gjw', '<cmd>Portal quickfix forward<cr>' },
        },
    },
}
