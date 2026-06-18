local snacks_picker = {
    'snacks',
    opts = {
        layout = {
            preset = 'default',
        },
        win = {
            input = {
                keys = {
                    ['<S-CR>'] = { 'confirm', mode = { 'n', 'i' } },
                },
            },
            list = {
                keys = {
                    ['<S-CR>'] = 'confirm',
                },
            },
        },
    },
}

local quick_picker = {
    'buffer',
    opts = {
        hotkeys = true,
        hotkeys_mode = 'text_diff_based',
        auto_preview = false,
        auto_accept = false,
        position = 'cursor',
        winborder = 'rounded',
        group_icon = '󰅂 ',
        keymaps = {
            preview = 'K',
            close = { 'q', '<Esc>' },
            select = { '<CR>', '<S-CR>' },
            back = '<BS>',
            preview_close = { 'q', '<Esc>', '<BS>' },
        },
        custom_keys = {
            { key = 'f', pattern = '[Ff]ix' },
            { key = 'a', pattern = '[Aa]dd' },
            { key = 'i', pattern = '[Ii]mport' },
            { key = 'o', pattern = '[Oo]rganize [Ii]mports' },
            { key = 'r', pattern = '[Rr]ename' },
            { key = 'e', pattern = '[Ee]xtract' },
            { key = 'm', pattern = '[Mm]atch' },
            { key = 'w', pattern = '[Ww]rap' },
        },
    },
}

local function code_action_with_picker(picker)
    return function()
        local tiny = require('tiny-code-action')
        tiny.config.picker = vim.deepcopy(picker)
        tiny.code_action()
    end
end

local function kind_priority(kind)
    if kind and kind:match('^quickfix') then
        return 1
    end
    if kind and kind:match('^refactor') then
        return 2
    end
    if kind == 'source.organizeImports' then
        return 3
    end
    if kind and kind:match('^source') then
        return 4
    end
    return 5
end

local function sort_code_actions(left, right)
    local left_preferred = left.action and left.action.isPreferred == true
    local right_preferred = right.action and right.action.isPreferred == true
    if left_preferred ~= right_preferred then
        return left_preferred
    end

    local left_kind = left.action and left.action.kind
    local right_kind = right.action and right.action.kind
    local left_priority = kind_priority(left_kind)
    local right_priority = kind_priority(right_kind)
    if left_priority ~= right_priority then
        return left_priority < right_priority
    end

    return (left.action and left.action.title or '') < (right.action and right.action.title or '')
end

local function setup_code_action_maps()
    vim.api.nvim_create_augroup('TinyCodeActionLspMaps', { clear = true })
    vim.api.nvim_create_autocmd('LspAttach', {
        group = 'TinyCodeActionLspMaps',
        callback = function(args)
            local opts = { buffer = args.buf }
            vim.keymap.set(
                { 'n', 'x' },
                'gla',
                code_action_with_picker(snacks_picker),
                vim.tbl_extend('force', opts, { desc = ' LSP code actions (Snacks preview)' })
            )
            vim.keymap.set(
                { 'n', 'x' },
                'gja',
                code_action_with_picker(quick_picker),
                vim.tbl_extend('force', opts, { desc = ' Quick LSP code actions' })
            )
        end,
    })
end

return {
    {
        'rachartier/tiny-code-action.nvim',
        dependencies = {
            'folke/snacks.nvim',
        },
        event = 'LspAttach',
        init = setup_code_action_maps,
        opts = {
            backend = 'vim',
            picker = snacks_picker,
            resolve_timeout = 500,
            sort = sort_code_actions,
            notify = {
                enabled = true,
                on_empty = true,
            },
            signs = {
                quickfix = { '', { link = 'DiagnosticWarn' } },
                others = { '', { link = 'DiagnosticInfo' } },
                refactor = { '', { link = 'DiagnosticInfo' } },
                ['refactor.move'] = { '󰪹', { link = 'DiagnosticInfo' } },
                ['refactor.extract'] = { '', { link = 'DiagnosticHint' } },
                ['source.organizeImports'] = { '', { link = 'DiagnosticWarn' } },
                ['source.fixAll'] = { '󰃢', { link = 'DiagnosticWarn' } },
                source = { '', { link = 'DiagnosticInfo' } },
                rename = { '󰑕', { link = 'DiagnosticWarn' } },
                codeAction = { '', { link = 'DiagnosticInfo' } },
            },
        },
    },
}
