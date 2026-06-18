local function title_text(title)
    if type(title) == 'string' then
        return title
    end

    if type(title) ~= 'table' then
        return ''
    end

    local chunks = {}
    for _, chunk in ipairs(title) do
        if type(chunk) == 'table' then
            if chunk[1] then
                table.insert(chunks, tostring(chunk[1]))
            end
        else
            table.insert(chunks, tostring(chunk))
        end
    end

    return table.concat(chunks)
end

local function describe_existing_buffer_map(buf, mode, lhs, desc)
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do
        if map.lhs == lhs then
            local opts = {
                buffer = buf,
                desc = desc,
                expr = map.expr == 1,
                nowait = map.nowait == 1,
                remap = map.noremap == 0,
                silent = map.silent == 1,
            }

            if map.callback then
                vim.keymap.set(mode, lhs, map.callback, opts)
            elseif map.rhs and map.rhs ~= '' then
                vim.keymap.set(mode, lhs, map.rhs, opts)
            end

            return
        end
    end
end

local function describe_buffer_maps(buf, maps)
    for _, map in ipairs(maps) do
        describe_existing_buffer_map(buf, map.mode or 'n', map[1], map.desc)
    end
end

local function describe_filetype_maps(filetype, maps, extra)
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dotfiles_search_replace_' .. filetype:gsub('%W', '_'), { clear = true }),
        pattern = filetype,
        callback = function(args)
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(args.buf) then
                    return
                end

                describe_buffer_maps(args.buf, maps)

                if extra then
                    extra(args.buf)
                end
            end)
        end,
    })
end

local muren_map_descriptions = {
    common = {
        { 'q', desc = 'Close Muren' },
        { 'gO', desc = 'Focus Muren options' },
        { 'gu', desc = 'Undo last Muren replacement' },
        { 'gU', desc = 'Redo last Muren replacement' },
        { '<Up>', desc = 'Scroll Muren preview up' },
        { '<Down>', desc = 'Scroll Muren preview down' },
    },
    input = {
        { '<S-CR>', desc = 'Apply Muren replacements' },
        { '<Tab>', desc = 'Switch Muren pattern/replacement pane' },
    },
    options = {
        { '<CR>', desc = 'Toggle Muren option' },
    },
}

local function describe_muren_maps()
    vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local ok, config = pcall(vim.api.nvim_win_get_config, win)
            if ok then
                local title = title_text(config.title)
                local buf = vim.api.nvim_win_get_buf(win)

                if title == 'patterns' or title == 'replacements' then
                    describe_buffer_maps(buf, muren_map_descriptions.common)
                    describe_buffer_maps(buf, muren_map_descriptions.input)
                elseif title == 'options' then
                    describe_buffer_maps(buf, muren_map_descriptions.common)
                    describe_buffer_maps(buf, muren_map_descriptions.options)
                end
            end
        end
    end)
end

return {
    {
        'AckslD/muren.nvim',
        opts = {
            two_step = true,
            keys = {
                close = 'q',
                toggle_side = '<Tab>',
                toggle_options_focus = 'gO',
                toggle_option_under_cursor = '<CR>',
                scroll_preview_up = '<Up>',
                scroll_preview_down = '<Down>',
                do_replace = '<S-CR>',
                do_undo = 'gu',
                do_redo = 'gU',
            },
            patterns_width = 120,
            patterns_height = 15,
            options_width = 50,
            preview_height = 45,
        },
        cmd = {
            'MurenToggle',
            'MurenOpen',
            'MurenClose',
            'MurenFresh',
            'MurenUnique',
        },
        config = function(_, opts)
            require('muren').setup(opts)
            vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
                group = vim.api.nvim_create_augroup('dotfiles_search_replace_muren', { clear = true }),
                callback = describe_muren_maps,
            })
        end,
        keys = {
            {
                'hrm',
                function()
                    vim.cmd.MurenToggle()
                    describe_muren_maps()
                end,
                desc = ' Replace: multi-pattern Muren',
            },
            {
                'hru',
                function()
                    vim.cmd.MurenUnique()
                    describe_muren_maps()
                end,
                desc = ' Replace: unique matches with Muren',
            },
        },
    },
    {
        'MagicDuck/grug-far.nvim',
        opts = {
            maxWorkers = 8,
            windowCreationCommand = 'tabnew',
            keymaps = {
                replace = { n = '<S-CR>' },
                qflist = { n = 'gq' },
                syncLocations = { n = 'gs' },
                syncLine = { n = 'gl' },
                syncNext = { n = 'gn' },
                syncPrev = { n = 'gN' },
                syncFile = { n = 'gf' },
                close = { n = 'q' },
                historyOpen = { n = 'gh' },
                historyAdd = { n = 'gH' },
                refresh = { n = 'gr' },
                openLocation = { n = 'go' },
                openNextLocation = { n = '<Down>' },
                openPrevLocation = { n = '<Up>' },
                gotoLocation = { n = '<CR>' },
                pickHistoryEntry = { n = '<CR>' },
                abort = { n = 'gb' },
                help = { n = '?' },
                toggleShowCommand = { n = 'gc' },
                swapEngine = { n = 'ge' },
                previewLocation = { n = 'gp' },
                swapReplacementInterpreter = { n = 'gi' },
                applyNext = { n = 'gj' },
                applyPrev = { n = 'gk' },
                nextInput = { n = '<Tab>' },
                prevInput = { n = '<S-Tab>' },
            },
        },
        keys = {
            {
                'hrg',
                function()
                    require('grug-far').open()
                end,
                desc = ' Replace: Grug project workbench',
            },
        },
        cmd = {
            'GrugFar',
            'GrugFarWithin',
        },
    },
    {
        'cshuaimin/ssr.nvim',
        opts = {
            max_width = 180,
            max_height = 60,
            keymaps = {
                replace_all = '<S-cr>',
            },
        },
        config = function(_, opts)
            require('ssr').setup(opts)
            describe_filetype_maps('ssr', {
                { 'q', desc = 'Close structural replace' },
                { '<CR>', desc = 'Confirm structural replacement' },
                { '<S-CR>', desc = 'Replace all structural matches' },
                { 'n', desc = 'Next structural match' },
                { 'N', desc = 'Previous structural match' },
            }, function(buf)
                vim.keymap.set('n', '?', function()
                    vim.notify(
                        table.concat({
                            'SSR mappings:',
                            '  <CR>   confirm each match',
                            '  <S-CR> replace all matches',
                            '  n/N    next/previous match',
                            '  q      close',
                        }, '\n'),
                        vim.log.levels.INFO,
                        { title = 'ssr.nvim' }
                    )
                end, { buffer = buf, nowait = true, desc = 'Show structural replace help' })
            end)
        end,
        keys = {
            {
                'hrr',
                function()
                    require('ssr').open()
                end,
                desc = ' Replace: structural Tree-sitter',
                mode = { 'n', 'x' },
            },
        },
    },
    {
        'chrisgrieser/nvim-rip-substitute',
        opts = {
            popupWin = {
                border = 'rounded',
            },
            incrementalPreview = {
                rangeBackdropBrightness = 80,
            },
        },
        cmd = 'RipSubstitute',
        config = function(_, opts)
            require('rip-substitute').setup(opts)
            describe_filetype_maps('rip-substitute', {
                { 'q', desc = 'Close rip-substitute' },
                { '<CR>', desc = 'Replace in buffer' },
                { '<S-CR>', desc = 'Replace in current working directory' },
                { '<Up>', desc = 'Previous replacement history entry' },
                { '<Down>', desc = 'Next replacement history entry' },
                { '<C-F>', desc = 'Toggle fixed-string search' },
                { '<C-C>', desc = 'Toggle ignore-case search' },
                { 'R', desc = 'Open search on regex101' },
                { '?', desc = 'Show rip-substitute help' },
            })
        end,
        keys = {
            {
                'hrs',
                function()
                    require('rip-substitute').sub()
                end,
                mode = { 'n', 'x' },
                desc = ' Replace: quick rip-substitute',
            },
        },
    },
}
