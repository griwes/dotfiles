local pretty_hover_ns = vim.api.nvim_create_namespace('pretty_hover_ns')

local hover_bufnr = nil
local hover_winnr = nil
local hover_dim_previous = nil

local function enable_hover_dim()
    if hover_dim_previous ~= nil then
        return
    end

    if vim.fn.exists(':VimadeFadeActive') ~= 2 then
        return
    end

    hover_dim_previous = vim.g.vimade_fade_active == 1
    if not hover_dim_previous then
        vim.cmd.VimadeFadeActive()
    end
end

local function clear_hover_dim()
    if hover_dim_previous == nil then
        return
    end

    local should_unfade = not hover_dim_previous
    hover_dim_previous = nil
    if should_unfade and vim.fn.exists(':VimadeUnfadeActive') == 2 then
        vim.cmd.VimadeUnfadeActive()
    end
end

local function redraw_vimade()
    if vim.fn.exists(':VimadeRedraw') == 2 then
        vim.cmd.VimadeRedraw()
    end
end

local function close_float()
    if hover_winnr and vim.api.nvim_win_is_valid(hover_winnr) then
        vim.api.nvim_win_close(hover_winnr, true)
    end

    hover_bufnr = nil
    hover_winnr = nil
    clear_hover_dim()
end

local function notify_no_information(config)
    if config.hover_cnf and config.hover_cnf.silent == true then
        return
    end

    vim.notify('No information available')
end

local function number_fallback()
    return require('pretty_hover.number').get_number_representations()
end

local function apply_pretty_hover_highlight(hl_data, bufnr, config, left_padding)
    vim.api.nvim_buf_clear_namespace(bufnr, pretty_hover_ns, 0, -1)

    for name, _ in pairs(config.hl) do
        local lines = hl_data.lines[tostring(name)]
        if lines then
            for _, line in pairs(lines) do
                if type(line) == 'table' and line.line_nr >= 0 then
                    local end_col = line.to
                    if end_col ~= -1 then
                        end_col = end_col + left_padding
                    end

                    vim.hl.range(
                        bufnr,
                        pretty_hover_ns,
                        'PH' .. tostring(name),
                        { line.line_nr, left_padding },
                        { line.line_nr, end_col }
                    )
                end
            end
        end
    end
end

local function open_float(contents, format, config)
    config = config or require('pretty_hover.config'):instance()

    if not contents or #contents == 0 then
        contents = number_fallback()
    end

    if not contents or #contents == 0 then
        notify_no_information(config)
        return nil, nil
    end

    local out = require('pretty_hover.parser').parse(contents)
    if #out.text == 0 then
        notify_no_information(config)
        return nil, nil
    end

    if config.toggle and hover_winnr and vim.api.nvim_win_is_valid(hover_winnr) then
        close_float()
        return nil, nil
    end

    local left_padding = 1
    local language = config.one_liner and vim.bo.filetype or format
    local padded = require('utils.float').pad_lines(out.text, { left = left_padding, right = 1 })

    enable_hover_dim()

    hover_bufnr, hover_winnr = vim.lsp.util.open_floating_preview(padded, language, {
        border = config.border,
        focus = true,
        focus_id = 'pretty-hover',
        focusable = true,
        max_height = config.max_height,
        max_width = config.max_width and config.max_width + 2 or nil,
        wrap = config.wrap,
        wrap_at = config.max_width and config.max_width or nil,
    })

    if not hover_bufnr or not hover_winnr then
        clear_hover_dim()
        return nil, nil
    end

    vim.w[hover_winnr].vimade_disabled = 1
    vim.b[hover_bufnr].vimade_disabled = 1
    redraw_vimade()

    local opened_winnr = hover_winnr
    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(opened_winnr),
        once = true,
        callback = function()
            if hover_winnr ~= opened_winnr then
                return
            end

            hover_bufnr = nil
            hover_winnr = nil
            clear_hover_dim()
        end,
    })

    vim.wo[hover_winnr].foldenable = false
    vim.bo[hover_bufnr].modifiable = false
    vim.bo[hover_bufnr].bufhidden = 'wipe'

    apply_pretty_hover_highlight(out.highlighting, hover_bufnr, config, left_padding)

    local pretty_hover_util = require('pretty_hover.core.util')
    vim.keymap.set('n', 'gf', pretty_hover_util.open_file_under_cursor, {
        buffer = hover_bufnr,
        silent = true,
        nowait = true,
    })

    vim.keymap.set('n', 'q', close_float, {
        buffer = hover_bufnr,
        silent = true,
        nowait = true,
    })

    return hover_bufnr, hover_winnr
end

local function patch_pretty_hover_float()
    local pretty_hover_util = require('pretty_hover.core.util')

    pretty_hover_util.close_float = close_float
    pretty_hover_util.open_float = open_float
end

return {
    {
        'Fildo7525/pretty_hover',
        event = 'LspAttach',
        opts = {},
        config = function(_, opts)
            require('pretty_hover').setup(opts)
            patch_pretty_hover_float()
        end,
        keys = {
            {
                'K',
                function()
                    require('pretty_hover').hover()
                end,
                desc = '󰔨 LSP hover',
            },
        },
    },
}
