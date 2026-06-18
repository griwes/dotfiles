local M = {}

local severity_names = {
    [vim.diagnostic.severity.ERROR] = 'Error',
    [vim.diagnostic.severity.WARN] = 'Warning',
    [vim.diagnostic.severity.INFO] = 'Info',
    [vim.diagnostic.severity.HINT] = 'Hint',
}

local severity_hls = {
    [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
    [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
    [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
}

local function diagnostic_icons()
    return require('utils.diagnostics').icons_by_severity
end

local function severity_name(severity)
    return severity_names[severity] or 'Diagnostic'
end

local function severity_hl(severity)
    return severity_hls[severity] or 'DiagnosticVirtualTextInfo'
end

local function add_close_keymaps(menu)
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

local function diagnostic_path(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name == '' then
        return '[No Name]'
    end

    local relative = vim.fn.fnamemodify(name, ':.')
    if relative ~= '' then
        return relative
    end

    return name
end

local function normalized_diagnostic(diagnostic, fallback_bufnr)
    local bufnr = diagnostic.bufnr or fallback_bufnr or 0

    return vim.tbl_extend('force', diagnostic, {
        bufnr = bufnr,
        path = diagnostic_path(bufnr),
        severity = diagnostic.severity or vim.diagnostic.severity.INFO,
    })
end

local function get_diagnostics(bufnr)
    if bufnr then
        return vim.tbl_map(function(diagnostic)
            return normalized_diagnostic(diagnostic, bufnr)
        end, vim.diagnostic.get(bufnr))
    end

    return vim.tbl_map(function(diagnostic)
        return normalized_diagnostic(diagnostic, diagnostic.bufnr)
    end, vim.diagnostic.get(nil))
end

local function sort_diagnostics(diagnostics)
    table.sort(diagnostics, function(a, b)
        if a.severity ~= b.severity then
            return a.severity < b.severity
        end
        if a.path ~= b.path then
            return a.path < b.path
        end
        if a.lnum ~= b.lnum then
            return a.lnum < b.lnum
        end
        return (a.col or 0) < (b.col or 0)
    end)

    return diagnostics
end

local function highest_severity(diagnostics)
    local highest = nil
    for _, diagnostic in ipairs(diagnostics) do
        if not highest or diagnostic.severity < highest then
            highest = diagnostic.severity
        end
    end

    if not highest then
        return diagnostics
    end

    return vim.tbl_filter(function(diagnostic)
        return diagnostic.severity == highest
    end, diagnostics)
end

local function diagnostic_source(diagnostic)
    local parts = {}
    if diagnostic.source and diagnostic.source ~= '' then
        table.insert(parts, diagnostic.source)
    end
    if diagnostic.code and diagnostic.code ~= '' then
        table.insert(parts, tostring(diagnostic.code))
    end

    if vim.tbl_isempty(parts) then
        return ''
    end

    return ' [' .. table.concat(parts, ':') .. ']'
end

local function compact_message(message)
    return (message or ''):gsub('%s+', ' '):gsub('^%s+', ''):gsub('%s+$', '')
end

local function highlight_span(highlights, text, start, hlgroup)
    -- Snipe format highlights are one-based relative to the formatted item
    -- text; nvim_buf_add_highlight receives them after Snipe offsets by the tag
    -- width. Keep call sites as zero-based byte offsets into the item text.
    table.insert(highlights, {
        first = start + 1,
        last = start + 1 + #text,
        hlgroup = hlgroup,
    })
end

local function format_diagnostic(diagnostic)
    local icons = diagnostic_icons()
    local icon = icons[diagnostic.severity] or require('utils.diagnostics').icons.diagnostics
    local severity = severity_name(diagnostic.severity)
    local location = ('%s:%d:%d'):format(diagnostic.path, diagnostic.lnum + 1, (diagnostic.col or 0) + 1)
    local source = diagnostic_source(diagnostic)
    local message = compact_message(diagnostic.message)
    local text = ('%s%s  %s%s  %s'):format(icon, severity, location, source, message)
    local hl = severity_hl(diagnostic.severity)
    local highlights = {}

    highlight_span(highlights, icon, 0, hl)
    highlight_span(highlights, severity, #icon, hl)
    highlight_span(highlights, location, #icon + #severity + 2, 'Comment')

    if source ~= '' then
        highlight_span(highlights, source, #icon + #severity + 2 + #location, 'DiagnosticUnnecessary')
    end

    return text, highlights
end

local function jump_to_diagnostic(diagnostic, source_win)
    if vim.api.nvim_win_is_valid(source_win) then
        vim.api.nvim_set_current_win(source_win)
    end

    if vim.api.nvim_buf_is_valid(diagnostic.bufnr) then
        vim.api.nvim_win_set_buf(0, diagnostic.bufnr)
    end

    local line_count = vim.api.nvim_buf_line_count(diagnostic.bufnr)
    local row = math.min((diagnostic.lnum or 0) + 1, line_count)
    local line = vim.api.nvim_buf_get_lines(diagnostic.bufnr, row - 1, row, false)[1] or ''
    local col = math.min(diagnostic.col or 0, #line)
    vim.api.nvim_win_set_cursor(0, { row, col })
end

local function open_diagnostics(opts)
    opts = opts or {}

    local diagnostics = get_diagnostics(opts.workspace and nil or 0)
    if opts.highest then
        diagnostics = highest_severity(diagnostics)
    end
    sort_diagnostics(diagnostics)

    if vim.tbl_isempty(diagnostics) then
        vim.notify('No diagnostics found', vim.log.levels.INFO, { title = 'Snipe diagnostics' })
        return
    end

    local Menu = require('snipe.menu')
    local scope = opts.workspace and 'Workspace' or 'Buffer'
    local title = scope .. (opts.highest and ' Highest-Severity Diagnostics' or ' Diagnostics')
    local source_win = vim.api.nvim_get_current_win()
    local menu = Menu:new({
        position = 'cursor',
        open_win_override = { title = title },
    })

    add_close_keymaps(menu)

    menu:open(diagnostics, function(m, i)
        local diagnostic = m.items[i]
        m:close()
        jump_to_diagnostic(diagnostic, source_win)
    end, format_diagnostic)
end

function M.open_buffer()
    open_diagnostics({ workspace = false })
end

function M.open_workspace()
    open_diagnostics({ workspace = true })
end

function M.open_buffer_highest()
    open_diagnostics({ workspace = false, highest = true })
end

function M.open_workspace_highest()
    open_diagnostics({ workspace = true, highest = true })
end

return M
