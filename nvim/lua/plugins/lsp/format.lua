return {
    {
        'stevearc/conform.nvim',
        event = 'VeryLazy',
        opts = {
            formatters_by_ft = {
                asm = { 'asmfmt' },
                cmake = { 'cmake_format' },
                lua = { 'stylua' },
            },
        },
        keys = {
            -- adapted from: https://github.com/stevearc/conform.nvim/issues/92#issuecomment-1751799876
            -- TODO: replace with native conform.nvim functionality if it materializes
            { '<leader>lf', function()
                -- local lines = vim.fn.system('git diff --unified=0'):gmatch('[^\n\r]+')
                local hunks = require('gitsigns').get_hunks()
                if hunks == nil then
                    return
                end
                local ranges = {}
                for _, hunk in ipairs(hunks) do
                    local line = hunk.head
                    local line_nums = line:match('%+.- ')
                    if line_nums:find(',') then
                        local _, _, first, second = line_nums:find('(%d+),(%d+)')
                        table.insert(ranges, {
                            start = { tonumber(first), 0 },
                            ['end'] = { tonumber(first) + tonumber(second), 0 },
                        })
                    else
                        local first = tonumber(line_nums:match('%d+'))
                        table.insert(ranges, {
                            start = { first, 0 },
                            ['end'] = { first + 1, 0 },
                        })
                    end
                end
                local format = require('conform').format
                for _, range in pairs(ranges) do
                    format({
                        range = range,
                        lsp_format = 'prefer',
                    })
                end
            end },
            { '<leader>lF', function() require('conform').format({ lsp_format = 'prefer' }) end }
        }
    },
}
