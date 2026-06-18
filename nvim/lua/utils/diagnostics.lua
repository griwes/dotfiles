local M = {}

M.icons = {
    error = ' ',
    warn = '󰀪 ',
    info = ' ',
    hint = ' ',
    diagnostics = '󰒡 ',
}

M.sign_text = {
    [vim.diagnostic.severity.ERROR] = M.icons.error,
    [vim.diagnostic.severity.WARN] = M.icons.warn,
    [vim.diagnostic.severity.INFO] = M.icons.info,
    [vim.diagnostic.severity.HINT] = M.icons.hint,
}

M.icons_by_severity = M.sign_text

function M.native_virtual_lines_enabled()
    return vim.g.dotfiles_diagnostic_virtual_lines == true
end

function M.virtual_lines()
    if not M.native_virtual_lines_enabled() then
        return false
    end

    return { current_line = true }
end

function M.apply_virtual_lines()
    vim.diagnostic.config({
        virtual_lines = M.virtual_lines(),
    })

    for _, client in pairs(vim.lsp.get_clients()) do
        local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)
        vim.diagnostic.config({
            virtual_lines = M.virtual_lines(),
        }, client_ns)
    end
end

function M.toggle_virtual_lines()
    vim.g.dotfiles_diagnostic_virtual_lines = not M.native_virtual_lines_enabled()
    if M.native_virtual_lines_enabled() then
        pcall(function()
            require('tiny-inline-diagnostic').disable()
        end)
    end
    M.apply_virtual_lines()

    vim.notify(
        (M.native_virtual_lines_enabled() and 'Enabled' or 'Disabled') .. ' native diagnostic virtual lines',
        vim.log.levels.INFO,
        { title = 'Diagnostics' }
    )
end

M.toggle_native_virtual_lines = M.toggle_virtual_lines

function M.toggle_inline_diagnostics()
    local ok, inline = pcall(require, 'tiny-inline-diagnostic')
    if not ok then
        vim.notify('tiny-inline-diagnostic.nvim is not available', vim.log.levels.WARN, { title = 'Diagnostics' })
        return
    end

    vim.g.dotfiles_diagnostic_virtual_lines = false
    M.apply_virtual_lines()
    inline.toggle()
end

local function format_float_diagnostic(diagnostic)
    return diagnostic.message:gsub('\n', ' \n')
end

local function float_prefix(_, index, total)
    local label = total > 1 and string.format('%d. ', index) or ''
    return ' ' .. label, 'NormalFloat'
end

local function float_suffix(diagnostic)
    local code = diagnostic.code and string.format(' [%s]', diagnostic.code) or ''
    return code .. ' ', 'NormalFloat'
end

local function open_float(opts)
    vim.diagnostic.open_float(
        nil,
        vim.tbl_extend('force', {
            border = 'rounded',
            focus = false,
            format = format_float_diagnostic,
            header = '',
            prefix = float_prefix,
            source = 'if_many',
            scope = 'cursor',
            suffix = float_suffix,
        }, opts or {})
    )
end

function M.open_float()
    open_float()
end

function M.open_float_focus()
    open_float({
        focus = true,
        focusable = true,
    })
end

function M.setloclist()
    vim.diagnostic.setloclist({ open = true })
end

function M.setqflist()
    vim.diagnostic.setqflist({ open = true })
end

return M
