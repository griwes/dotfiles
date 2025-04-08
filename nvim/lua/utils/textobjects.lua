local textobject_mappings = {
    f = '@function',
    c = '@class',
    l = '@loop',
    C = '@comment',
}

local M = {}

M.jumpable_textobjects = {
    '.*.outer',
    'parameter.inner',
}

function M.select_keymaps()
    local ret = {}

    for key, name in pairs(textobject_mappings) do
        ret['a' .. key] = name .. '.outer'
        ret['i' .. key] = name .. '.inner'
    end

    return ret
end

function M.setup_nap()
    local nap = require('nap')
    local txtobj = require('nvim-treesitter.textobjects.move')
    for key, name in pairs(textobject_mappings) do
        local function gen(next, prev, desc_suffix)
            return {
                next = {
                    rhs = function()
                        next(name .. '.outer')
                    end,
                    opts = {
                        desc = 'Next ' .. name .. desc_suffix,
                    }
                },
                prev = {
                    rhs = function()
                        prev(name .. '.outer')
                    end,
                    opts = {
                        desc = 'Prev ' .. name .. desc_suffix,
                    }
                },
                mode = { 'n', 'v', 'o', },
            }
        end

        nap.map(key, gen(txtobj.goto_next_start, txtobj.goto_previous_start, ''))
        nap.map(']' .. key, gen(txtobj.goto_next_end, txtobj.goto_previous_end, ' end'))
    end
end

return M
