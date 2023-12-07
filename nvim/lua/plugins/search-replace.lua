return {
    {
        'gabrielpoca/replacer.nvim',
        opts = {
        },
        keys = {
            { '<leader>r', function() require('replacer').run() end },
        }
    }
}
