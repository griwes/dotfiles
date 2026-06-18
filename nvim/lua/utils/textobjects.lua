local M = {}

M.jumpable_textobjects = {
    '.*.outer',
    'parameter.inner',
}

M.textobjects = {
    { key = 'f', capture = '@function', label = 'function', icon = '󰊕 ', move = true },
    { key = 'c', capture = '@class', label = 'class', icon = ' ', move = true },
    { key = ',', capture = '@parameter', label = 'parameter', icon = '󰏪 ', move = true, selection_mode = 'v' },
    { key = 'o', capture = '@call', label = 'call', icon = '󰃷 ', selection_mode = 'v' },
    { key = 'C', capture = '@conditional', label = 'conditional', icon = '󰘦 ', move = true },
    { key = 'W', capture = '@loop', label = 'loop', icon = '󰑖 ', move = true },
    { key = 'b', capture = '@block', label = 'block', icon = '󰆦 ', move = true },
    { key = ';', capture = '@statement', label = 'statement', icon = '󰅩 ', move = true },
    { key = '=', capture = '@assignment', label = 'assignment', icon = '󰬔 ', move = true, selection_mode = 'v' },
    { key = 'R', capture = '@return', label = 'return', icon = '󰌑 ', move = true },
    { key = '#', capture = '@comment', label = 'comment', icon = '󰅺 ', move = true },
    { key = '@', capture = '@attribute', label = 'attribute', icon = '󰓹 ', move = true, selection_mode = 'v' },
}

M.textobject_mappings = {}
for _, spec in ipairs(M.textobjects) do
    M.textobject_mappings[spec.key] = spec.capture
end

function M.selection_modes()
    local modes = {}
    for _, spec in ipairs(M.textobjects) do
        local selection_mode = spec.selection_mode or 'V'
        modes[spec.capture .. '.inner'] = selection_mode
        modes[spec.capture .. '.outer'] = selection_mode
    end
    return modes
end

function M.each(callback)
    for _, spec in ipairs(M.textobjects) do
        callback(spec)
    end
end

local function textobject_move(capture, direction)
    return function()
        local move = require('nvim-treesitter-textobjects.move')
        move[direction](capture)
    end
end

function M.setup_bracket_nav()
    local bracket_nav = require('utils.bracket_nav')

    for _, spec in ipairs(M.textobjects) do
        if spec.move then
            bracket_nav.map(spec.key, {
                mode = { 'n', 'x', 'o' },
                icon = spec.icon,
                desc = spec.label,
                next = textobject_move(spec.capture .. '.outer', 'goto_next_start'),
                prev = textobject_move(spec.capture .. '.outer', 'goto_previous_start'),
            })
        end
    end
end

return M
