local M = {}

local cmp = require('cmp')
local config = require('cmp.config')
local luasnip = require('luasnip')

M.max_prefix = ''
M.is_fixed = false

local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local fake_view = {
    open = require('cmp.view').open,
    event = {}
}

function fake_view:_get_entries_view()
    local ret = {}

    function ret:open(offset, entries)
        local line = vim.api.nvim_buf_get_lines(
            0, M._current_context.cursor.row, M._current_context.cursor.row + 1, false)
        M.max_prefix = string.sub(
            line[1], M._current_context.cursor.col - offset, M._current_context.cursor.col)
    end

    return ret
end

function fake_view.event:emit()
end

function M.source(opts)
    opts.entry_filter = M.entry_filter
    return opts
end

function M.tab(fallback)
    if cmp.visible() then
        local ctx = cmp.core.context
        if M.is_fixed == false then
            M.is_fixed = true
            M._current_context = ctx
            fake_view:open(ctx, config.get().sources)
        else
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end
    elseif luasnip.expandable() then
        luasnip.expand()
    elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
    elseif has_words_before() then
        cmp.complete()
    else
        fallback()
    end
end

function M.s_tab(fallback)
end

return M
