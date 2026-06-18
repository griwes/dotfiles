local function has_gersemi_config(bufnr)
    bufnr = bufnr or 0
    local filename = vim.api.nvim_buf_get_name(bufnr)
    if filename == '' then
        return false
    end

    return vim.fs.find('.gersemirc', {
        path = vim.fs.dirname(filename),
        upward = true,
    })[1] ~= nil
end

local function format_opts(opts)
    opts = vim.tbl_extend('force', {
        lsp_format = 'prefer',
    }, opts or {})

    local bufnr = opts.bufnr or 0
    if vim.bo[bufnr].filetype == 'cmake' and has_gersemi_config(bufnr) then
        opts.lsp_format = 'fallback'
    end

    return opts
end

local function current_vgit_buffer(bufnr)
    local ok = pcall(require, 'vgit')
    if not ok then
        return nil
    end

    local store = require('vgit.git.git_buffer_store')
    store.collect()
    return store.get({ bufnr = bufnr })
end

local function changed_hunk_ranges(bufnr)
    local buffer = current_vgit_buffer(bufnr)
    if not buffer then
        return {}
    end

    require('vgit.core.loop').free_textlock()
    local hunks, err = buffer:diff()
    if err then
        vim.notify(table.concat(err, '\n'), vim.log.levels.WARN, { title = 'VGit hunks' })
        return {}
    end

    hunks = hunks or buffer:get_hunks() or {}

    local ranges = {}
    local line_count = vim.api.nvim_buf_line_count(bufnr)
    for _, hunk in ipairs(hunks) do
        if hunk.type ~= 'remove' then
            local top = math.max(hunk.top, 1)
            local bot = math.min(hunk.bot, line_count)
            if top <= bot then
                ranges[#ranges + 1] = {
                    start = { top, 0 },
                    ['end'] = { bot + 1, 0 },
                }
            end
        end
    end

    table.sort(ranges, function(left, right)
        return left.start[1] > right.start[1]
    end)

    return ranges
end

local function format_changed_hunks()
    local bufnr = vim.api.nvim_get_current_buf()

    require('vgit.core.loop').coroutine(function()
        local format = require('conform').format
        for _, range in ipairs(changed_hunk_ranges(bufnr)) do
            format(format_opts({
                bufnr = bufnr,
                range = range,
            }))
        end
    end)()
end

return {
    {
        'stevearc/conform.nvim',
        event = 'VeryLazy',
        opts = {
            -- Conform owns editor orchestration. Binary ownership is split by
            -- tool role: mise owns generally useful tools such as stylua, while
            -- Mason owns editor-only formatter helpers such as asmfmt/cmakelang.
            formatters_by_ft = {
                asm = { 'asmfmt' },
                cmake = { 'gersemi', 'cmake_format', stop_after_first = true },
                lua = { 'stylua' },
            },
            formatters = {
                gersemi = {
                    require_cwd = true,
                },
            },
        },
        keys = {
            -- TODO: replace with native conform.nvim functionality if it materializes
            {
                'glf',
                format_changed_hunks,
                desc = '󰉢 Format changed hunks',
            },
            {
                'glF',
                function()
                    require('conform').format(format_opts())
                end,
                desc = '󰉢 Format buffer',
            },
        },
    },
}
