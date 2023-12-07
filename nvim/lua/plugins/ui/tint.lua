return {
    {
        'levouh/tint.nvim',
        dependencies = {
            'lukas-reineke/indent-blankline.nvim',
        },
        event = 'VeryLazy',
        priority = 0,
        config = function()
            vim.api.nvim_create_augroup('Tint', { clear = false })
            vim.api.nvim_create_autocmd('User', {
                group = 'Tint',
                pattern = 'LazyLoad',
                callback = require('tint').refresh
            })

            require('tint').setup({
                tint = -50,
                highlight_ignore_patterns = { 'WinSeparator', 'Status.*', 'VertSplit', 'ibl.*', 'GitSigns.*Inline', 'lualine_.*' },
                window_ignore_function = function(winid)
                    local bufid = vim.api.nvim_win_get_buf(winid)
                    local buftype = vim.api.nvim_buf_get_option(bufid, 'buftype')
                    local filetype = vim.api.nvim_buf_get_option(bufid, 'filetype')
                    local floating = vim.api.nvim_win_get_config(winid).relative ~= ''

                    -- Do not tint `terminal` or floating windows or dap UI, tint everything else
                    return buftype == 'terminal' or
                        floating or
                        filetype:find('dap', 1, true) == 1 or
                        filetype == 'Trouble'
                end
            })
        end,
    }
}
