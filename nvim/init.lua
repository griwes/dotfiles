require('core')
require('lazy-config')
require('keybinds')

-- TODO: move this
if vim.g.neovide ~= nil then
    vim.cmd [[
        highlight! link Substitute CurSearch

        highlight! default FloatBorder blend=75
        highlight! default CursorLine blend=75
        highlight! default FloatTitle blend=75
        highlight! default Title blend=75
    ]]
else
    vim.cmd [[
        highlight! link Substitute CurSearch

        highlight! default FloatBorder blend=0
        highlight! default CursorLine blend=0
        highlight! default FloatTitle blend=0
        highlight! default Title blend=0
    ]]
end

-- This is a hack for marks.nvim always forcibly setting numhl on signs.
local mark_utils = require('marks.utils')
local original_add_sign = mark_utils.add_sign
---@diagnostic disable-next-line: duplicate-set-field
mark_utils.add_sign = function(bufnr, text, line, id, group, priority)
    local sign_name = 'Marks_' .. text
    vim.fn.sign_define(sign_name, { text = text, texthl = 'MarkSignHL', numhl = nil })
    mark_utils.sign_cache[sign_name] = true
    original_add_sign(bufnr, text, line, id, group, priority)
end

