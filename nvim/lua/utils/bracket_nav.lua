local M = {}

local state = {
    next = nil,
    prev = nil,
    opts = {
        next_prefix = ']',
        prev_prefix = '[',
        next_repeat = '<M-]>',
        prev_repeat = '<M-[>',
    },
}

local function modes(spec)
    return spec.mode or spec.modes or 'n'
end

local function notify_error(err)
    vim.notify('[bracket-nav] ' .. tostring(err), vim.log.levels.ERROR)
end

local function run(command)
    local ok, err = pcall(command.action)
    if not ok then
        notify_error(err)
    end
end

local function repeat_command(direction)
    return function()
        local command = state[direction]
        if not command then
            vim.notify('[bracket-nav] Nothing to repeat', vim.log.levels.INFO)
            return
        end

        run(command)
    end
end

local function set_repeat_pair(pair)
    state.next = pair.next
    state.prev = pair.prev
end

local function default_desc(direction, spec)
    local icon = spec.icon or ''
    if icon ~= '' and not icon:match('%s$') then
        icon = icon .. ' '
    end
    local label = spec.desc or spec.label or spec.name or spec.operator
    local prefix = direction == 'next' and 'Next ' or 'Previous '
    return icon .. prefix .. label
end

function M.setup(opts)
    state.opts = vim.tbl_extend('force', state.opts, opts or {})

    vim.keymap.set({ 'n', 'x', 'o' }, state.opts.next_repeat, repeat_command('next'), {
        desc = '󰒭 Repeat next bracket jump',
        silent = true,
    })
    vim.keymap.set({ 'n', 'x', 'o' }, state.opts.prev_repeat, repeat_command('prev'), {
        desc = '󰒮 Repeat previous bracket jump',
        silent = true,
    })
end

function M.map(operator, spec)
    spec = spec or {}
    spec.operator = operator

    local pair = {
        next = {
            lhs = spec.next_lhs or (state.opts.next_prefix .. operator),
            action = assert(spec.next, 'missing next action for ' .. operator),
            desc = spec.next_desc or default_desc('next', spec),
        },
        prev = {
            lhs = spec.prev_lhs or (state.opts.prev_prefix .. operator),
            action = assert(spec.prev, 'missing previous action for ' .. operator),
            desc = spec.prev_desc or default_desc('prev', spec),
        },
    }

    local function map(command)
        vim.keymap.set(modes(spec), command.lhs, function()
            set_repeat_pair(pair)
            run(command)
        end, {
            buffer = spec.buffer,
            desc = command.desc,
            silent = spec.silent ~= false,
        })
    end

    map(pair.next)
    map(pair.prev)
end

function M.command(command)
    return function()
        vim.cmd(command)
    end
end

return M
