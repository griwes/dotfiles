return {
    {
        'ethanholz/nvim-lastplace',
        event = 'VeryLazy',
        opts = {
        },
    },
    {
        'chrisgrieser/nvim-spider',
        event = 'VeryLazy',
        opts = {
            skipInsignificantPunctuation = false
        }
    },
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        init = function()
            vim.cmd [[
                highlight! FlashMatch guifg=#f6b079 guibg=None gui=bold
                highlight! FlashLabel guifg=#7ad5d6 guibg=None gui=bold
            ]]
        end,
        opts = {
            label = {
                uppercase = false,
            },
            modes = {
                search = {
                    highlight = {
                        backdrop = true,
                    },
                    search = {
                        multi_window = false,
                        incremental = true,
                    },
                },
                char = {
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                '<leader>w',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump({

                        search = {
                            mode = function(pattern)
                                -- remove leading dot
                                if pattern:sub(1, 1) == "." then
                                    pattern = pattern:sub(2)
                                end
                                -- return word pattern and proper skip pattern
                                return ([[\<%s\w*\>]]):format(pattern), ([[\<%s]]):format(pattern)
                            end,
                        },
                        label = {
                            after = false,
                            before = true,
                        },
                    })
                end,
                desc = 'Flash word jump'
            },
            {
                '<leader>s',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump()
                end,
                desc = 'Flash search'
            },
            {
                '<leader>n',
                mode = { 'n', 'v', 'x', 'o' },
                function()
                    require('flash').jump({
                        matcher = function(win --[[@param win integer]], state --[[@param state Flash.State]])
                            if state.pattern.pattern:len() == 0 then
                                return {}
                            end

                            local buf = vim.api.nvim_win_get_buf(win)
                            local ts_utils = require('nvim-treesitter.ts_utils')
                            local jumpable = require('utils.textobjects').jumpable_textobjects

                            local query = vim.treesitter.query.get(vim.bo[buf].ft, 'textobjects')
                            local nac = ts_utils.get_node_at_cursor(win)
                            if not query or not nac then
                                return {}
                            end

                            local function matches(capture)
                                if not capture:match('^' .. state.pattern.pattern .. '.*') then
                                    return false
                                end

                                for _, txtobj in ipairs(jumpable) do
                                    if capture:match(txtobj) then
                                        return true
                                    end
                                end
                                return false
                            end

                            local root = ts_utils.get_root_for_node(nac)
                            local ret = {}
                            for id, node in query:iter_captures(root, buf) do
                                local startr, startc, endr, endc = node:range(false)
                                if matches(query.captures[id]) then
                                    table.insert(ret, {
                                        win = win,
                                        buf = buf,
                                        pos = { startr + 1, startc },
                                        end_pos = { endr + 1, endc },
                                    })
                                end
                            end
                            return ret
                        end,
                        actions = {
                            [require('flash.util').CR] = function(state, _)
                                state:hide()
                                require('flash').jump({
                                    matcher = function(win, new_state)
                                        return vim.tbl_filter(function(value)
                                            if value.win ~= win then
                                                return false
                                            end
                                            local text = vim.api.nvim_buf_get_text(value.buf, value.pos[1] - 1,
                                                    value.pos[2],
                                                    value.pos[1] - 1,
                                                    value.pos[1] == value.end_pos[1] and value.end_pos[2] - 1 or -1, {})
                                                [1]
                                                :lower()
                                            return text:match('^' .. new_state.pattern.pattern:lower() .. '.*')
                                        end, state.results)
                                    end,
                                    search = {
                                        multi_window = true,
                                        incremental = true,
                                    },
                                    jump = {
                                        autojump = false,
                                    },
                                    label = {
                                        after = false,
                                        before = true,
                                    },
                                    mode = 'fuzzy',
                                })
                            end
                        },
                        search = {
                            multi_window = true,
                            incremental = true,
                        },
                        jump = {
                            autojump = false,
                        },
                        label = {
                            after = false,
                            before = true,
                        },
                    })
                end,
                desc = 'Flash treesitter jump',
            }
        },
    },
    {
        'liangxianzhe/nap.nvim',
        event = 'VeryLazy',
        config = function()
            local nap = require('nap')

            --- @param label string
            --- @param severity vim.diagnostic.Severity?
            --- @return table
            local setup_diag = function(label, severity)
                return {
                    next = {
                        rhs = function()
                            vim.diagnostic.jump({ severity = severity, count = 1, float = false })
                        end,
                        opts = { desc = 'Next ' .. label }
                    },
                    prev = {
                        rhs = function()
                            vim.diagnostic.jump({ severity = severity, count = -1, float = false })
                        end,
                        opts = { desc = 'Prev ' .. label }
                    },
                    mode = { 'n', 'v', 'o' },
                }
            end

            local sev = vim.diagnostic.severity
            nap.setup({
                next_repeat = '<M-]>',
                prev_repeat = '<M-[>',
                operators = {
                    d = setup_diag('diagnostic', nil),
                    e = setup_diag('error', sev.ERROR),
                    w = setup_diag('warning', sev.WARN),
                    i = setup_diag('info', sev.INFO),
                    h = setup_diag('hint', sev.HINT),
                },
                exclude_default_operators = { 't', 'T', },
            })

            nap.map('c', nap.gitsigns())
            nap.map('r', nap.illuminate())
            require('utils.textobjects').setup_nap()
        end
    },
}
