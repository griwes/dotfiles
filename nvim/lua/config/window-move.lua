local direction_commands = {
    left = {
        neighbor = 'h',
        far = 'H',
        label = 'left',
    },
    down = {
        neighbor = 'j',
        far = 'J',
        label = 'down',
    },
    up = {
        neighbor = 'k',
        far = 'K',
        label = 'up',
    },
    right = {
        neighbor = 'l',
        far = 'L',
        label = 'right',
    },
}

local move_mode_keys = {
    j = 'left',
    k = 'down',
    l = 'up',
    [';'] = 'right',
    J = 'far_left',
    K = 'far_down',
    L = 'far_up',
    [':'] = 'far_right',
    ['<Left>'] = 'left',
    ['<Down>'] = 'down',
    ['<Up>'] = 'up',
    ['<Right>'] = 'right',
    ['<S-Left>'] = 'far_left',
    ['<S-Down>'] = 'far_down',
    ['<S-Up>'] = 'far_up',
    ['<S-Right>'] = 'far_right',
}

local exit_keys = {
    q = true,
    ['<Esc>'] = true,
    ['<C-C>'] = true,
}

local function notify(message)
    vim.notify(message, vim.log.levels.INFO, { title = 'Window move' })
end

local function normal_windows()
    return vim.tbl_filter(function(win)
        local config = vim.api.nvim_win_get_config(win)
        return config.relative == '' and config.focusable ~= false
    end, vim.api.nvim_tabpage_list_wins(0))
end

local function window_label(win)
    local bufnr = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == '' then
        name = '[No Name]'
    else
        name = vim.fn.fnamemodify(name, ':~:.')
    end

    return string.format('%d: %s', vim.fn.win_id2win(win), name)
end

local function with_window(win, callback)
    local current = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(win)
    local ok, result = pcall(callback)
    if vim.api.nvim_win_is_valid(current) then
        vim.api.nvim_set_current_win(current)
    end
    if not ok then
        error(result)
    end
    return result
end

local function capture_window(win)
    return {
        bufnr = vim.api.nvim_win_get_buf(win),
        view = with_window(win, vim.fn.winsaveview),
    }
end

local function restore_window(win, state)
    vim.api.nvim_win_set_buf(win, state.bufnr)
    with_window(win, function()
        vim.fn.winrestview(state.view)
    end)
end

local function swap_windows(left, right, focus)
    if left == right or not vim.api.nvim_win_is_valid(left) or not vim.api.nvim_win_is_valid(right) then
        return
    end

    local left_state = capture_window(left)
    local right_state = capture_window(right)

    restore_window(left, right_state)
    restore_window(right, left_state)

    if focus and vim.api.nvim_win_is_valid(focus) then
        vim.api.nvim_set_current_win(focus)
    end
end

local function neighbor_window(direction)
    local command = direction_commands[direction]
    if command == nil then
        return nil
    end

    local current = vim.api.nvim_get_current_win()
    vim.cmd('wincmd ' .. command.neighbor)
    local target = vim.api.nvim_get_current_win()
    vim.api.nvim_set_current_win(current)

    if target == current then
        return nil
    end

    return target
end

local function move_one(direction)
    local target = neighbor_window(direction)
    if target == nil then
        notify('No window ' .. direction_commands[direction].label)
        return
    end

    local current = vim.api.nvim_get_current_win()
    swap_windows(current, target, target)
end

local function move_far(direction)
    local command = direction_commands[direction]
    if command == nil then
        return
    end

    if #normal_windows() < 2 then
        notify('No other windows')
        return
    end

    vim.cmd('wincmd ' .. command.far)
end

local function move(action)
    local far_direction = action:match('^far_(.+)$')
    if far_direction then
        move_far(far_direction)
        return
    end

    move_one(action)
end

local function swap_pick()
    local current = vim.api.nvim_get_current_win()
    local choices = vim.tbl_map(
        function(win)
            return {
                win = win,
                label = window_label(win),
            }
        end,
        vim.tbl_filter(function(win)
            return win ~= current
        end, normal_windows())
    )

    if #choices == 0 then
        notify('No other windows')
        return
    end

    vim.ui.select(choices, {
        prompt = 'Swap with window',
        format_item = function(item)
            return item.label
        end,
    }, function(choice)
        if choice == nil then
            return
        end

        swap_windows(current, choice.win, choice.win)
    end)
end

local function move_mode()
    notify('j/k/l/; move, J/K/L/: far move, q/Esc exit')

    while true do
        local ok, key = pcall(vim.fn.getcharstr)
        if not ok then
            return
        end

        local translated = vim.fn.keytrans(key)
        if exit_keys[key] or exit_keys[translated] then
            return
        end

        local action = move_mode_keys[key] or move_mode_keys[translated]
        if action then
            move(action)
            vim.cmd.redraw()
        end
    end
end

local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('<C-w>m', move_mode, '󰘕 Move window mode')
map('<C-w>x', swap_pick, '󰓡 Swap window')

map('<C-w><C-j>', function()
    move('left')
end, '󰁍 Move window left')
map('<C-w><C-S-j>', function()
    move('far_left')
end, '󰁍 Move window far left')
map('<C-w><C-k>', function()
    move('down')
end, '󰁅 Move window down')
map('<C-w><C-S-k>', function()
    move('far_down')
end, '󰁅 Move window far down')
map('<C-w><C-l>', function()
    move('up')
end, '󰁝 Move window up')
map('<C-w><C-S-l>', function()
    move('far_up')
end, '󰁝 Move window far up')
map('<C-w><C-;>', function()
    move('right')
end, '󰁔 Move window right')
map('<C-w><C-S-;>', function()
    move('far_right')
end, '󰁔 Move window far right')
