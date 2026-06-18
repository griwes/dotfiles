local namespace = vim.api.nvim_create_namespace('dotfiles-two-key-escape')

local mapping = { 'j', 'k' }
local feeding = false
local swallow_mapped_tail = false
local pending_preemptive = nil
local pending_repair = nil

-- Keep `jk` escape snappy; `timeoutlen` is intentionally too forgiving here.
local repair_timeout_ms = 150
local preemptive_timeouts_ms = {
    operator = 150,
    terminal = 100,
    visual = 100,
}

local function now_ms()
    return vim.uv.hrtime() / 1000000
end

local function timeout_ms(ms)
    return math.min(vim.o.timeoutlen, ms)
end

local function termcodes(keys)
    return vim.api.nvim_replace_termcodes(keys, true, false, true)
end

local function feed(keys, mode)
    feeding = true
    vim.api.nvim_feedkeys(termcodes(keys), mode or 'n', false)
    vim.defer_fn(function()
        feeding = false
    end, 0)
end

local function requeue_typed(keys)
    feeding = true
    vim.api.nvim_feedkeys(termcodes(keys), 'mit', false)
    vim.defer_fn(function()
        feeding = false
    end, 0)
end

local function mark_mapped_tail(key, typed)
    if typed ~= nil and typed ~= '' and key ~= typed then
        swallow_mapped_tail = true
    end
end

local function typed_key(typed)
    if typed == nil or typed == '' then
        return nil
    end

    return typed
end

local function mode_kind(mode)
    local head = mode:sub(1, 1)

    if mode:sub(1, 2) == 'no' then
        return 'operator'
    end

    if mode == 'c' then
        return 'command'
    end

    if mode == 't' or mode:sub(1, 1) == 't' or mode:find('t', 1, true) then
        return 'terminal'
    end

    if head == 'i' then
        return 'insert'
    end

    if head == 'R' then
        return 'replace'
    end

    if head == 'v' or head == 'V' or head == 's' or head == 'S' or mode:find('\22', 1, true) then
        return 'visual'
    end

    if mode == 'n' then
        return 'normal'
    end

    return nil
end

local function preemptive_escape(kind)
    if kind == 'terminal' then
        return '<C-\\><C-n>', 'nt'
    end

    return '<Esc>', 'nt'
end

local function restore_clean_insert_escape(pending)
    if pending.modified then
        return
    end

    vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(pending.bufnr) then
            return
        end

        if vim.bo[pending.bufnr].modified and (vim.b[pending.bufnr].changedtick or 0) <= pending.changedtick + 3 then
            vim.bo[pending.bufnr].modified = false
        end
    end, 0)
end

local function restore_insert_snapshot(pending)
    if not vim.api.nvim_buf_is_valid(pending.bufnr) then
        return
    end

    vim.api.nvim_buf_set_lines(pending.bufnr, pending.cursor[1] - 1, pending.cursor[1], false, { pending.line })

    if vim.api.nvim_win_is_valid(pending.winid) then
        vim.api.nvim_set_current_win(pending.winid)
        vim.api.nvim_win_set_cursor(pending.winid, pending.cursor)
    end
end

local function delete_command_j()
    local line = vim.fn.getcmdline()
    local pos = vim.fn.getcmdpos()
    if pos <= 1 then
        return
    end

    vim.fn.setcmdline(line:sub(1, pos - 2) .. line:sub(pos), pos - 1)
end

local function capture_repair(kind, mode)
    local bufnr = vim.api.nvim_get_current_buf()
    local winid = vim.api.nvim_get_current_win()

    return {
        at = now_ms(),
        bufnr = bufnr,
        changedtick = vim.b[bufnr].changedtick or 0,
        cursor = vim.api.nvim_win_get_cursor(winid),
        kind = kind,
        line = vim.api.nvim_get_current_line(),
        mode = mode,
        modified = vim.bo[bufnr].modified,
        view = vim.fn.winsaveview(),
        winid = winid,
    }
end

local function pending_matches(pending, mode)
    return pending.mode == mode
        and pending.bufnr == vim.api.nvim_get_current_buf()
        and now_ms() - pending.at <= timeout_ms(repair_timeout_ms)
end

local function repair_current_chord(pending)
    if pending.kind == 'normal' then
        if vim.api.nvim_win_is_valid(pending.winid) then
            vim.api.nvim_set_current_win(pending.winid)
            vim.api.nvim_win_set_cursor(pending.winid, pending.cursor)
            vim.fn.winrestview(pending.view)
        end
        return
    end

    if pending.kind == 'insert' or pending.kind == 'replace' then
        vim.schedule(function()
            vim.cmd.stopinsert()
            restore_insert_snapshot(pending)
            restore_clean_insert_escape(pending)
        end)
        return
    end

    if pending.kind == 'command' then
        delete_command_j()
        feed('<C-c>')
    end
end

local function handle_repair(key, typed, mode, kind)
    local input = typed_key(typed)
    if input == nil then
        return nil
    end

    local pending = pending_repair

    if pending ~= nil then
        pending_repair = nil

        if input == mapping[2] and pending_matches(pending, mode) then
            mark_mapped_tail(key, typed)
            repair_current_chord(pending)
            return ''
        end
    end

    if input == mapping[1] then
        pending_repair = capture_repair(kind, mode)
    end

    return nil
end

local function clear_preemptive()
    pending_preemptive = nil
end

local function replay_preemptive(pending, followup)
    local keys = mapping[1]
    if followup ~= nil and followup ~= '' then
        keys = keys .. followup
    end

    requeue_typed(keys)
end

local function start_preemptive(mode, kind)
    local pending = {
        bufnr = vim.api.nvim_get_current_buf(),
        kind = kind,
        mode = mode,
    }
    pending_preemptive = pending

    vim.defer_fn(function()
        if pending_preemptive ~= pending then
            return
        end

        clear_preemptive()
        replay_preemptive(pending)
    end, timeout_ms(preemptive_timeouts_ms[kind]))
end

local function handle_pending_preemptive(key, typed, mode)
    local pending = pending_preemptive
    if pending == nil then
        return nil
    end

    if pending.mode ~= mode or pending.bufnr ~= vim.api.nvim_get_current_buf() then
        clear_preemptive()
        return nil
    end

    clear_preemptive()
    mark_mapped_tail(key, typed)

    local input = typed_key(typed)
    if input == nil then
        pending_preemptive = pending
        return nil
    end

    if input == mapping[2] then
        swallow_mapped_tail = true
        local escape, feed_mode = preemptive_escape(pending.kind)
        feed(escape, feed_mode)
        return ''
    end

    replay_preemptive(pending, input)
    return ''
end

local function handle_preemptive(key, typed, mode, kind)
    if typed_key(typed) ~= mapping[1] then
        return nil
    end

    mark_mapped_tail(key, typed)
    start_preemptive(mode, kind)
    return ''
end

vim.on_key(function(key, typed)
    if swallow_mapped_tail then
        if typed == nil or typed == '' then
            return ''
        end

        swallow_mapped_tail = false
    end

    if feeding or key == '' then
        return
    end

    local mode = vim.api.nvim_get_mode().mode
    local kind = mode_kind(mode)

    local pending_result = handle_pending_preemptive(key, typed, mode)
    if pending_result ~= nil then
        return pending_result
    end

    if preemptive_timeouts_ms[kind] ~= nil then
        return handle_preemptive(key, typed, mode, kind)
    end

    if kind == 'insert' or kind == 'replace' or kind == 'command' or kind == 'normal' then
        return handle_repair(key, typed, mode, kind)
    end
end, namespace)
