local function is_multiline_string_node(node)
    local node_type = node:type()
    if
        not (
            node_type:find('string', 1, true)
            or node_type:find('heredoc', 1, true)
            or node_type == 'template_string'
            or node_type == 'template_string_content'
            or node_type == 'template_substitution'
        )
    then
        return false
    end

    local start_row, _, end_row = node:range()
    return end_row > start_row
end

local function cursor_is_in_multiline_string(buf)
    local ok, node = pcall(vim.treesitter.get_node, {
        bufnr = buf,
        ignore_injections = true,
    })
    if not ok then
        return false
    end

    while node do
        if is_multiline_string_node(node) then
            return true
        end

        node = node:parent()
    end

    return false
end

local function install_document_highlight_filter()
    local default_handler = vim.lsp.handlers['textDocument/documentHighlight']

    vim.lsp.handlers['textDocument/documentHighlight'] = function(err, result, ctx, config)
        if err or not result then
            return default_handler(err, result, ctx, config)
        end

        if #result <= 1 then
            return
        end

        return default_handler(err, result, ctx, config)
    end
end

local function preview_git_status_without_external_diff(ctx)
    local status = ctx.item.status
    if not status or status:find('^[A?]') then
        return Snacks.picker.preview.file(ctx)
    end

    local terminal = ctx.picker.opts.previewers.diff.style == 'terminal'
    local cmd = { 'git' }
    if not terminal then
        cmd[#cmd + 1] = '--no-pager'
    end

    vim.list_extend(cmd, ctx.picker.opts.previewers.git.args or {})
    vim.list_extend(cmd, { 'diff', '--no-ext-diff' })
    if status:find('[UAD][UAD]') then
        cmd[#cmd + 1] = '--cc'
    elseif status:sub(1, 1) ~= ' ' then
        cmd[#cmd + 1] = '--cached'
    end

    if ctx.item.file then
        vim.list_extend(cmd, { '--', ctx.item.file })
    end

    return Snacks.picker.preview.cmd(cmd, ctx, {
        ft = not terminal and 'diff' or nil,
    })
end

return {
    {
        'folke/snacks.nvim',
        lazy = false,
        priority = 1000,
        init = function()
            require('snacks')
            install_document_highlight_filter()

            require('utils.bracket_nav').map('r', {
                mode = { 'n', 'x', 'o' },
                icon = '󰈇 ',
                desc = 'highlighted reference',
                next = function()
                    Snacks.words.jump(vim.v.count1)
                end,
                prev = function()
                    Snacks.words.jump(-vim.v.count1)
                end,
            })

            vim.api.nvim_create_augroup('SnacksLspPickerMaps', { clear = true })
            vim.api.nvim_create_autocmd('LspAttach', {
                group = 'SnacksLspPickerMaps',
                callback = function(args)
                    local opts = { buffer = args.buf }
                    vim.keymap.set(
                        'n',
                        'glr',
                        Snacks.picker.lsp_references,
                        vim.tbl_extend('force', opts, { desc = '󰈇 LSP references' })
                    )
                    vim.keymap.set(
                        'n',
                        'gld',
                        Snacks.picker.lsp_definitions,
                        vim.tbl_extend('force', opts, { desc = '󰳽 LSP definitions' })
                    )
                    vim.keymap.set(
                        'n',
                        'glD',
                        Snacks.picker.lsp_declarations,
                        vim.tbl_extend('force', opts, { desc = '󰳽 LSP declarations' })
                    )
                    vim.keymap.set(
                        'n',
                        'glt',
                        Snacks.picker.lsp_type_definitions,
                        vim.tbl_extend('force', opts, { desc = ' LSP type definitions' })
                    )
                    vim.keymap.set(
                        'n',
                        'gli',
                        Snacks.picker.lsp_implementations,
                        vim.tbl_extend('force', opts, { desc = '󰡱 LSP implementations' })
                    )
                end,
            })
        end,
        opts = {
            bufdelete = {
                enabled = true,
            },
            explorer = {
                enabled = true,
                replace_netrw = false,
            },
            input = {
                enabled = true,
            },
            notifier = {
                enabled = true,
                top_down = false,
            },
            picker = {
                previewers = {
                    git = {
                        builtin = false,
                    },
                },
                sources = {
                    explorer = {
                        win = {
                            list = {
                                keys = {
                                    h = false,
                                    j = 'explorer_close',
                                    k = 'list_down',
                                    l = 'list_up',
                                    [';'] = 'confirm',
                                    a = false,
                                    c = false,
                                    d = false,
                                    m = false,
                                    p = false,
                                    r = false,
                                },
                            },
                        },
                    },
                    git_status = {
                        preview = preview_git_status_without_external_diff,
                    },
                    gh_diff = {
                        auto_close = false,
                        layout = {
                            preset = 'right',
                            hidden = { 'preview' },
                        },
                    },
                    undo = {
                        previewers = {
                            diff = {
                                wo = {
                                    breakindent = false,
                                    linebreak = false,
                                    wrap = false,
                                },
                            },
                        },
                    },
                },
            },
            styles = {
                float = {
                    backdrop = false,
                },
            },
            terminal = {},
            words = {
                debounce = 75,
                filter = function(buf)
                    if vim.g.snacks_words == false or vim.b[buf].snacks_words == false then
                        return false
                    end

                    return not cursor_is_in_multiline_string(buf)
                end,
                modes = { 'n', 'i', 'c' },
                notify_end = true,
                notify_jump = false,
            },
        },
        keys = function()
            require('snacks')
            local diagnostics = require('utils.diagnostics')
            local function diagnostic_picker(opts)
                return function()
                    Snacks.picker.diagnostics(opts)
                end
            end

            return {
                {
                    'hbd',
                    function()
                        require('snacks').bufdelete()
                    end,
                    desc = 'Buffer delete (layout preserving)',
                },
                {
                    '<C-Esc><C-Esc>',
                    function()
                        require('snacks.notifier').hide()
                    end,
                    desc = 'Dismiss all notifications',
                },
                {
                    'hzz',
                    function()
                        Snacks.zen.zoom()
                    end,
                    desc = 'Toggle zoom on current buffer',
                },
                {
                    'hzf',
                    function()
                        if Snacks.dim.enabled then
                            Snacks.dim.disable()
                        else
                            Snacks.dim.enable()
                        end
                    end,
                    desc = 'Toggle focus dimming',
                },
                {
                    'hGl',
                    function()
                        Snacks.gitbrowse({ what = 'permalink' })
                    end,
                    mode = { 'n', 'v' },
                    desc = 'Open git permalink',
                },

                { 'htt', Snacks.picker.pickers, desc = '󰱼 Pick picker' },
                { 'htf', Snacks.picker.files, desc = '󰈞 Pick file' },
                { 'htw', Snacks.picker.grep_word, desc = '󰊄 Search word' },
                { 'hts', Snacks.picker.grep, desc = '󰊄 Search text' },
                { 'htg', Snacks.picker.git_files, desc = ' Pick git file' },
                { 'htG', Snacks.picker.git_status, desc = ' Pick git status' },
                { 'htb', Snacks.picker.buffers, desc = ' Pick buffer' },
                { 'htj', Snacks.picker.jumps, desc = '󰁔 Pick jump' },
                { 'htq', Snacks.picker.qflist, desc = '󰁨 Pick quickfix item' },
                { 'htl', Snacks.picker.loclist, desc = '󰍉 Pick loclist item' },
                { 'htu', Snacks.picker.undo, desc = ' Pick undo state' },
                {
                    'hf',
                    function()
                        Snacks.explorer.reveal()
                    end,
                    desc = '󰉋 Reveal file in explorer',
                },

                {
                    'hdd',
                    Snacks.picker.diagnostics_buffer,
                    desc = diagnostics.icons.diagnostics .. 'Buffer diagnostics',
                },
                { 'hdD', Snacks.picker.diagnostics, desc = diagnostics.icons.diagnostics .. 'Workspace diagnostics' },
                {
                    'hde',
                    diagnostic_picker({ severity = vim.diagnostic.severity.ERROR }),
                    desc = diagnostics.icons.error .. 'Error diagnostics',
                },
                {
                    'hdw',
                    diagnostic_picker({ severity = vim.diagnostic.severity.WARN }),
                    desc = diagnostics.icons.warn .. 'Warning diagnostics',
                },
                {
                    'hdi',
                    diagnostic_picker({ severity = vim.diagnostic.severity.INFO }),
                    desc = diagnostics.icons.info .. 'Info diagnostics',
                },
                {
                    'hdh',
                    diagnostic_picker({ severity = vim.diagnostic.severity.HINT }),
                    desc = diagnostics.icons.hint .. 'Hint diagnostics',
                },
                { 'hdf', diagnostics.open_float, desc = diagnostics.icons.diagnostics .. 'Diagnostic detail' },
                {
                    'hdF',
                    diagnostics.open_float_focus,
                    desc = diagnostics.icons.diagnostics .. 'Focusable diagnostic detail',
                },
                { 'hdq', diagnostics.setloclist, desc = diagnostics.icons.diagnostics .. 'Diagnostics to loclist' },
                { 'hdQ', diagnostics.setqflist, desc = diagnostics.icons.diagnostics .. 'Diagnostics to quickfix' },
                {
                    'hdl',
                    diagnostics.toggle_inline_diagnostics,
                    desc = diagnostics.icons.diagnostics .. 'Toggle inline diagnostics',
                },
            }
        end,
    },
    {
        'folke/noice.nvim',
        event = 'User NoiceUiReady',
        init = function()
            local function neovide_message_ui_is_clear()
                for _, ui in ipairs(vim.api.nvim_list_uis()) do
                    if ui.ext_messages or ui.ext_cmdline then
                        return false
                    end
                end

                return true
            end

            local function fire_noice_ready()
                vim.api.nvim_exec_autocmds('User', {
                    pattern = 'NoiceUiReady',
                    modeline = false,
                })
            end

            local function wait_for_builtin_message_ui()
                local tries = 0

                local function check()
                    if neovide_message_ui_is_clear() then
                        fire_noice_ready()
                        return
                    end

                    tries = tries + 1
                    if tries < 100 then
                        vim.defer_fn(check, 20)
                        return
                    end

                    vim.notify(
                        'Noice not loaded: an attached UI still owns ext_messages/ext_cmdline',
                        vim.log.levels.WARN
                    )
                end

                check()
            end

            if vim.g.did_very_lazy then
                wait_for_builtin_message_ui()
            else
                vim.api.nvim_create_autocmd('User', {
                    pattern = 'VeryLazy',
                    once = true,
                    callback = wait_for_builtin_message_ui,
                })
            end
        end,
        dependencies = {
            'folke/snacks.nvim',
        },
        opts = {
            cmdline = {
                enabled = true,
            },
            messages = {
                enabled = true,
            },
            notify = {
                enabled = false,
            },
            popupmenu = {
                enabled = false,
            },
            lsp = {
                progress = {
                    enabled = false,
                },
                hover = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                },
                message = {
                    enabled = false,
                },
                documentation = {
                    enabled = false,
                },
            },
            presets = {
                inc_rename = true,
            },
        },
    },
}
