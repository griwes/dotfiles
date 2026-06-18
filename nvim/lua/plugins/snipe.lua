local function create_command(name, callback)
    pcall(vim.api.nvim_del_user_command, name)
    vim.api.nvim_create_user_command(name, callback, {})
end

local function open_lsp_symbols()
    require('utils.snipe.lsp').open_symbols()
end

local function open_lsp_symbols_split()
    require('utils.snipe.lsp').open_symbols_split()
end

local function open_lsp_symbols_vsplit()
    require('utils.snipe.lsp').open_symbols_vsplit()
end

local function open_spell_suggestions()
    require('utils.snipe.spell').open()
end

local function open_buffer_diagnostics()
    require('utils.snipe.diagnostics').open_buffer()
end

local function open_workspace_diagnostics()
    require('utils.snipe.diagnostics').open_workspace()
end

local function open_buffer_highest_diagnostics()
    require('utils.snipe.diagnostics').open_buffer_highest()
end

local function open_workspace_highest_diagnostics()
    require('utils.snipe.diagnostics').open_workspace_highest()
end

local max_recent_buffers = 15

local function first_n(items, limit)
    local result = {}
    for index = 1, math.min(limit, #items) do
        result[index] = items[index]
    end
    return result
end

local function open_recent_buffers()
    local snipe = require('snipe')
    local buffers = first_n(require('snipe.buffer').get_buffers('ls t'), max_recent_buffers)
    local format_buffer = snipe.create_buffer_formatter(buffers)

    snipe.global_menu:add_new_buffer_callback(snipe.default_keymaps)
    snipe.global_menu:open(buffers, snipe.default_select, format_buffer)
end

local function setup_lsp_symbol_maps()
    local group = vim.api.nvim_create_augroup('SnipeLspSymbols', { clear = true })

    create_command('SnipeLspSymbols', open_lsp_symbols)
    create_command('SnipeLspSymbolsSplit', open_lsp_symbols_split)
    create_command('SnipeLspSymbolsVSplit', open_lsp_symbols_vsplit)
    create_command('SnipeSpell', open_spell_suggestions)
    create_command('SnipeDiagnostics', open_buffer_diagnostics)
    create_command('SnipeWorkspaceDiagnostics', open_workspace_diagnostics)
    create_command('SnipeHighestDiagnostics', open_buffer_highest_diagnostics)
    create_command('SnipeWorkspaceHighestDiagnostics', open_workspace_highest_diagnostics)

    vim.api.nvim_create_autocmd('LspAttach', {
        group = group,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client or not client.server_capabilities.documentSymbolProvider then
                return
            end

            local opts = { buffer = args.buf }
            vim.keymap.set(
                'n',
                'gjs',
                open_lsp_symbols,
                vim.tbl_extend('force', opts, { desc = '󰱼 Open Snipe LSP symbols' })
            )
            vim.keymap.set(
                'n',
                'gjS',
                open_lsp_symbols_split,
                vim.tbl_extend('force', opts, { desc = '󰱼 Open Snipe LSP symbols in split' })
            )
            vim.keymap.set(
                'n',
                'gjV',
                open_lsp_symbols_vsplit,
                vim.tbl_extend('force', opts, { desc = '󰱼 Open Snipe LSP symbols in vertical split' })
            )
        end,
    })
end

local function apply_snipe_highlights()
    local groups = {
        SnipeHint = { link = 'Boolean' },
        SnipeText = { link = 'Normal' },
        SnipeFilename = { link = 'SnipeText' },
        SnipeDirname = { link = 'Comment' },
    }

    for name, definition in pairs(groups) do
        vim.api.nvim_set_hl(0, name, definition)
    end

    local ok, highlights = pcall(require, 'snipe.highlights')
    if not ok then
        return
    end

    for _, hl_group in pairs(highlights.highlight_groups) do
        vim.api.nvim_set_hl(highlights.highlight_ns, hl_group.name, hl_group.definition)
    end
end

local function refresh_snipe_windows()
    apply_snipe_highlights()

    local ok, highlights = pcall(require, 'snipe.highlights')
    if not ok then
        return
    end

    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == 'snipe-menu' then
            pcall(vim.api.nvim_win_set_hl_ns, win, highlights.highlight_ns)
        end
    end
end

local function schedule_snipe_highlight_refresh()
    vim.schedule(refresh_snipe_windows)
    vim.defer_fn(refresh_snipe_windows, 25)
    vim.defer_fn(refresh_snipe_windows, 100)
end

local function setup_snipe_highlight_policy()
    local group = vim.api.nvim_create_augroup('SnipeHighlightPolicy', { clear = true })

    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = apply_snipe_highlights,
    })

    vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter', 'WinEnter' }, {
        group = group,
        callback = function(args)
            local buf = args.buf or vim.api.nvim_get_current_buf()
            if vim.bo[buf].filetype == 'snipe-menu' then
                schedule_snipe_highlight_refresh()
            end
        end,
    })
end

return {
    {
        'leath-dub/snipe.nvim',
        init = setup_lsp_symbol_maps,
        opts = {
            ui = {
                position = 'cursor',
                persist_tags = false,
            },
            navigate = {
                next_page = 'K',
                prev_page = 'J',
            },
            sort = 'last',
        },
        config = function(_, opts)
            require('snipe').setup(opts)
            setup_snipe_highlight_policy()
            apply_snipe_highlights()
        end,
        keys = {
            {
                'gjb',
                open_recent_buffers,
                desc = ' Open recent Snipe buffer menu',
            },
            { 'gjd', open_buffer_diagnostics, desc = '󰒡 Open Snipe buffer diagnostics' },
            {
                'gjD',
                open_workspace_diagnostics,
                desc = '󰒡 Open Snipe workspace diagnostics',
            },
            {
                'gjh',
                open_buffer_highest_diagnostics,
                desc = '󰒡 Open Snipe highest-severity buffer diagnostics',
            },
            {
                'gjH',
                open_workspace_highest_diagnostics,
                desc = '󰒡 Open Snipe highest-severity workspace diagnostics',
            },
            { 'gjz', open_spell_suggestions, desc = '󰓆 Open Snipe spell suggestions' },
        },
    },
}
