-- Adapted from kungfusheep/snipe-lsp.nvim:
-- https://github.com/kungfusheep/snipe-lsp.nvim at 2770b5ff0cc923af23d53542620fa64f909a6a6e.
-- Upstream license: MIT, Copyright (c) 2024 Pete Griffiths.
-- MIT permission notice: permission is granted, free of charge, to use, copy,
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the
-- software, subject to preserving the copyright and permission notice.
-- Local changes: flatten nested symbols, reuse Blink's configured kind
-- icons/highlights, expose functions directly for lazy keymaps, and avoid
-- plugin-owned keymaps.

local M = {}

local symbol_to_blink_kind = {
    File = 'File',
    Module = 'Module',
    Namespace = 'Module',
    Package = 'Module',
    Class = 'Class',
    Method = 'Method',
    Property = 'Property',
    Field = 'Field',
    Constructor = 'Constructor',
    Enum = 'Enum',
    Interface = 'Interface',
    Function = 'Function',
    Variable = 'Variable',
    Constant = 'Constant',
    String = 'Text',
    Number = 'Value',
    Boolean = 'Value',
    Array = 'Value',
    Object = 'Value',
    Key = 'Property',
    Null = 'Value',
    EnumMember = 'EnumMember',
    Struct = 'Struct',
    Event = 'Event',
    Operator = 'Operator',
    TypeParameter = 'TypeParameter',
}

local function symbol_kind_name(kind)
    return vim.lsp.protocol.SymbolKind[kind] or 'Unknown'
end

local function blink_kind(symbol_kind)
    return symbol_to_blink_kind[symbol_kind] or 'Field'
end

local function blink_kind_icons()
    local ok, config = pcall(require, 'blink.cmp.config')
    if ok and config.appearance and config.appearance.kind_icons then
        return config.appearance.kind_icons
    end

    ok, config = pcall(require, 'blink.cmp.config.appearance')
    if ok and config.default and config.default.kind_icons then
        return config.default.kind_icons
    end

    return {}
end

local function kind_icon(symbol_kind)
    local icons = blink_kind_icons()
    return icons[blink_kind(symbol_kind)] or icons.Field or ''
end

local function kind_hl(symbol_kind)
    return 'BlinkCmpKind' .. blink_kind(symbol_kind)
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

local function add_symbol(items, symbol, bufnr, depth)
    local range = symbol.selectionRange or symbol.range or (symbol.location and symbol.location.range)
    if not range then
        return
    end

    local item_bufnr = bufnr
    if symbol.location and symbol.location.uri then
        item_bufnr = vim.uri_to_bufnr(symbol.location.uri)
    end

    table.insert(items, {
        name = symbol.name,
        kind = symbol.kind,
        kind_name = symbol_kind_name(symbol.kind),
        range = range,
        bufnr = item_bufnr,
        depth = depth,
    })

    for _, child in ipairs(symbol.children or {}) do
        add_symbol(items, child, bufnr, depth + 1)
    end
end

local function get_document_symbols(bufnr)
    local params = {
        textDocument = vim.lsp.util.make_text_document_params(bufnr),
    }

    local responses = vim.lsp.buf_request_sync(bufnr, 'textDocument/documentSymbol', params, 1000)
    if not responses or vim.tbl_isempty(responses) then
        vim.notify('No symbols found', vim.log.levels.INFO)
        return {}
    end

    local items = {}
    for _, response in pairs(responses) do
        if response.result then
            for _, symbol in ipairs(response.result) do
                add_symbol(items, symbol, bufnr, 0)
            end
        end
    end

    if vim.tbl_isempty(items) then
        vim.notify('No symbols found', vim.log.levels.INFO)
    end

    return items
end

local function symbol_position(symbol)
    local line_count = vim.api.nvim_buf_line_count(symbol.bufnr)
    local row = math.min(symbol.range.start.line + 1, line_count)
    local line = vim.api.nvim_buf_get_lines(symbol.bufnr, row - 1, row, false)[1] or ''
    local col = math.min(symbol.range.start.character, #line)

    return { row, col }
end

local function jump_to_symbol(symbol, source_win, split)
    if split then
        vim.cmd(split)
        source_win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(source_win, symbol.bufnr)
    elseif vim.api.nvim_win_is_valid(source_win) then
        vim.api.nvim_set_current_win(source_win)
    end

    vim.api.nvim_win_set_cursor(source_win, symbol_position(symbol))
end

local function format_symbol(symbol)
    local icon = kind_icon(symbol.kind_name)
    local hl = kind_hl(symbol.kind_name)
    local indent = string.rep('  ', symbol.depth)
    local label = indent .. symbol.name
    local kind = symbol.kind_name
    local icon_prefix = icon ~= '' and icon .. ' ' or ''
    local text = icon_prefix .. label .. '  ' .. kind
    local kind_start = #text - #kind + 1
    local highlights = {
        { first = kind_start, last = kind_start + #kind, hlgroup = hl },
    }

    if icon ~= '' then
        table.insert(highlights, 1, { first = 1, last = 1 + #icon, hlgroup = hl })
    end

    return text, highlights
end

local function open_symbols(split)
    local Menu = require('snipe.menu')
    local symbols = get_document_symbols(0)
    if vim.tbl_isempty(symbols) then
        return
    end

    local source_win = vim.api.nvim_get_current_win()
    local title = split and 'LSP Document Symbols -> Split' or 'LSP Document Symbols'
    local menu = Menu:new({
        position = 'cursor',
        open_win_override = { title = title },
    })

    add_close_keymaps(menu)

    menu:open(symbols, function(m, i)
        local symbol = m.items[i]
        m:close()
        jump_to_symbol(symbol, source_win, split)
    end, format_symbol)
end

function M.open_symbols()
    open_symbols()
end

function M.open_symbols_split()
    open_symbols('split')
end

function M.open_symbols_vsplit()
    open_symbols('vsplit')
end

return M
