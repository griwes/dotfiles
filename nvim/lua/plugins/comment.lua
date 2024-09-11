return {
    {
        'numToStr/Comment.nvim',
        lazy = false,
        opts = function()
            return {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }
        end,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = false,
        opts = {
            enable_autocmd = false,
        },
    },
}
