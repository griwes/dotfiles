local function update_commentstring(args)
    local ok, context = pcall(require, 'ts_context_commentstring')
    if not ok then
        return
    end

    pcall(context.update_commentstring, args)
end

local function visual_start_location()
    local ok, utils = pcall(require, 'ts_context_commentstring.utils')
    if ok then
        return utils.get_visual_start_location()
    end

    local pos = vim.fn.getpos('\'<')
    return { pos[2] - 1, math.max(pos[3] - 1, 0) }
end

local function update_for_comment()
    local mode = vim.fn.mode()
    if mode == 'v' or mode == 'V' or mode == vim.keycode('<C-v>') then
        update_commentstring({
            location = visual_start_location(),
        })
        return
    end

    update_commentstring()
end

local function operator_rhs()
    update_for_comment()
    return require('vim._comment').operator()
end

local function line_rhs()
    update_for_comment()
    return require('vim._comment').operator() .. '_'
end

-- TODO: Core currently covers linewise `gc`/`gcc`, but not a blockwise
-- `gb`/`gbc`-style toggle. If that becomes important, add a narrow local
-- block-toggle helper here rather than bringing back a full comment plugin.
vim.keymap.set({ 'n', 'x' }, 'gc', operator_rhs, {
    expr = true,
    desc = 'Toggle comment',
})
vim.keymap.set('n', 'gcc', line_rhs, {
    expr = true,
    desc = 'Toggle comment line',
})
