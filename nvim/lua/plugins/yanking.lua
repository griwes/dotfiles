local function is_visual()
    return vim.fn.mode():sub(1, 1) ~= 'n'
end

local function yank()
    return require('yanky').yank()
end

local function put(kind, wrapper)
    return function()
        require('yanky').put(kind, is_visual(), wrapper and wrapper())
    end
end

local function cycle(direction)
    return function()
        require('yanky').cycle(direction)
    end
end

local function linewise()
    return require('yanky.wrappers').linewise()
end

local function linewise_change(change)
    return function()
        local wrappers = require('yanky.wrappers')
        return wrappers.linewise(wrappers.change(change))
    end
end

return {
    {
        'gbprod/yanky.nvim',
        dependencies = {
            'kkharji/sqlite.lua',
        },
        event = 'VeryLazy',
        opts = {
            ring = {
                history_length = 16384,
                storage = 'sqlite',
            },
            textobj = {
                enable = true,
            },
        },
        keys = {
            -- TODO: history picker
            {
                'y',
                yank,
                mode = { 'n', 'x' },
                expr = true,
                desc = ' Yank text',
            },
            {
                'p',
                put('p'),
                mode = { 'n', 'x' },
                desc = ' Put yanked text after cursor',
            },
            {
                'P',
                put('P'),
                mode = { 'n', 'x' },
                desc = ' Put yanked text before cursor',
            },
            {
                'gp',
                put('gp'),
                mode = { 'n', 'x' },
                desc = ' Put yanked text after selection',
            },
            {
                'gP',
                put('gP'),
                mode = { 'n', 'x' },
                desc = ' Put yanked text before selection',
            },

            {
                '<C-M-p>',
                cycle(1),
                desc = ' Select previous entry through yank history',
            },
            { '<C-M-n>', cycle(-1), desc = ' Select next entry through yank history' },
            { ']p', put(']p', linewise), desc = ' Put indented after cursor (linewise)' },
            { '[p', put('[p', linewise), desc = ' Put indented before cursor (linewise)' },
            { ']P', put(']p', linewise), desc = ' Put indented after cursor (linewise)' },
            { '[P', put('[p', linewise), desc = ' Put indented before cursor (linewise)' },
            { '>p', put('p', linewise_change('>>')), desc = ' Put and indent right' },
            { '<p', put('p', linewise_change('<<')), desc = ' Put and indent left' },
            { '>P', put('P', linewise_change('>>')), desc = ' Put before and indent right' },
            { '<P', put('P', linewise_change('<<')), desc = ' Put before and indent left' },
            { '=p', put('p', linewise_change('==')), desc = ' Put after applying a filter' },
            { '=P', put('P', linewise_change('==')), desc = ' Put before applying a filter' },

            {
                'ylp',
                function()
                    require('yanky.textobj').last_put()
                end,
                mode = { 'o', 'x' },
                desc = ' Last put',
            },
        },
    },
}
