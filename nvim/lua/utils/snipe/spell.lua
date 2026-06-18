-- Adapted from kungfusheep/snipe-spell.nvim:
-- https://github.com/kungfusheep/snipe-spell.nvim at 973b3d70ea026d9b43b56c4834c19ee85b3b1372.
-- Upstream license: MIT, Copyright (c) 2024 Pete Griffiths.
-- MIT permission notice: permission is granted, free of charge, to use, copy,
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the
-- software, subject to preserving the copyright and permission notice.
-- Local changes: expose a direct function for lazy keymaps, use window-local
-- spell enablement on demand, add close/confirm menu keys, and replace text
-- through buffer APIs instead of normal-command string interpolation.

local M = {}

local function misspelled_word()
    if not vim.wo.spell then
        vim.wo.spell = true
    end

    local word = vim.fn.spellbadword()[1]
    if word == '' then
        vim.notify('No misspelled word under the cursor', vim.log.levels.INFO)
        return nil
    end

    return word
end

local function suggestions(word)
    local items = vim.fn.spellsuggest(word, 10, 'best')
    if vim.tbl_isempty(items) then
        vim.notify('No suggestions found', vim.log.levels.INFO)
    end

    return items
end

local function word_range(line, word, cursor_col)
    local best_start, best_finish
    local start_at = 1

    while true do
        local start_col, finish_col = line:find(word, start_at, true)
        if not start_col then
            break
        end

        if start_col <= cursor_col + 1 and finish_col >= cursor_col then
            return start_col, finish_col
        end

        if not best_start or math.abs(start_col - cursor_col) < math.abs(best_start - cursor_col) then
            best_start, best_finish = start_col, finish_col
        end

        start_at = finish_col + 1
    end

    return best_start, best_finish
end

local function replace_word(word, replacement)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    local start_col, finish_col = word_range(line, word, col)

    if not start_col then
        vim.notify('Could not find misspelled word on the current line', vim.log.levels.WARN)
        return
    end

    vim.api.nvim_buf_set_text(0, row - 1, start_col - 1, row - 1, finish_col, { replacement })
    vim.api.nvim_win_set_cursor(0, { row, start_col - 1 + #replacement })
end

local function add_menu_keymaps(menu)
    menu:add_new_buffer_callback(function(m)
        local opts = { nowait = true, buffer = m.buf }

        vim.keymap.set('n', '<esc>', function()
            m:close()
        end, opts)

        vim.keymap.set('n', 'q', function()
            m:close()
        end, opts)

        vim.keymap.set('n', '<cr>', function()
            local hovered = m:hovered()
            m.tag_followed(m, hovered, false)
        end, opts)
    end)
end

function M.open()
    local word = misspelled_word()
    if not word then
        return
    end

    local items = suggestions(word)
    if vim.tbl_isempty(items) then
        return
    end

    local Menu = require('snipe.menu')
    local menu = Menu:new({
        position = 'cursor',
        open_win_override = { title = 'Spell Suggestions' },
    })

    add_menu_keymaps(menu)

    menu:open(items, function(m, i)
        local replacement = m.items[i]
        m:close()
        replace_word(word, replacement)
    end)
end

return M
