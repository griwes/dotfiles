local function fix_end_character_position(bufnr, range)
    if range['end'].character ~= 0 or range['end'].line <= range.start.line then
        return
    end

    range['end'].line = range['end'].line - 1
    range['end'].character = #vim.api.nvim_buf_get_lines(bufnr, range['end'].line - 1, range['end'].line, false)[1]
end

local function comment_scope()
    return {
        callback = function(display)
            local scope = vim.deepcopy(display.focus_node.scope)
            fix_end_character_position(display.for_buf, scope)

            display.state.leaving_window_for_action = true
            local ok, err = pcall(function()
                vim.api.nvim_set_current_win(display.for_win)
                local has_context, context = pcall(require, 'ts_context_commentstring')
                if has_context then
                    pcall(context.update_commentstring, {
                        location = { scope.start.line - 1, scope.start.character },
                    })
                end
                require('vim._comment').toggle_lines(scope.start.line, scope['end'].line, {
                    scope.start.line,
                    scope.start.character,
                })
            end)

            if vim.api.nvim_win_is_valid(display.mid.winid) then
                vim.api.nvim_set_current_win(display.mid.winid)
            end
            display.state.leaving_window_for_action = false

            if not ok then
                vim.notify(err, vim.log.levels.ERROR)
            end
        end,
        description = 'Comment scope',
    }
end

return {
    {
        'hasansujon786/nvim-navbuddy',
        dependencies = {
            'neovim/nvim-lspconfig',
            'SmiteshP/nvim-navic',
            'MunifTanjim/nui.nvim',
        },
        opts = {
            window = {
                border = 'rounded',
                size = '75%',
                sections = {
                    left = {
                        size = '30%',
                    },
                    mid = {
                        size = '35%',
                    },
                    right = {},
                },
            },
            lsp = {
                auto_attach = true,
            },
            node_markers = {
                enabled = true,
                icons = {
                    leaf = '  ',
                    leaf_selected = ' →  ',
                    branch = '   ',
                },
            },
            use_default_mappings = false,
        },
        config = function(_, opts)
            local actions = require('nvim-navbuddy.actions')

            opts.mappings = {
                ['<esc>'] = actions.close(),
                ['q'] = actions.close(),

                ['k'] = actions.next_sibling(),
                ['l'] = actions.previous_sibling(),

                ['j'] = actions.parent(),
                [';'] = actions.children(),
                ['0'] = actions.root(),

                ['nv'] = actions.visual_name(),
                ['v'] = actions.visual_scope(),

                ['ny'] = actions.yank_name(),
                ['y'] = actions.yank_scope(),

                ['ni'] = actions.insert_name(),
                ['i'] = actions.insert_scope(),

                ['na'] = actions.append_name(),
                ['a'] = actions.append_scope(),

                ['nr'] = actions.rename(),

                ['d'] = actions.delete(),

                ['zf'] = actions.fold_create(),
                ['zd'] = actions.fold_delete(),

                ['gc'] = comment_scope(),

                ['<enter>'] = actions.select(),

                ['K'] = actions.move_down(),
                ['L'] = actions.move_up(),

                ['p'] = actions.toggle_preview(),

                ['<C-v>'] = actions.vsplit(),
                ['<C-h>'] = actions.hsplit(),

                ['g?'] = actions.help(),
            }

            require('nvim-navbuddy').setup(opts)
        end,
        cmd = {
            'Navbuddy',
        },
        keys = {
            {
                'hln',
                function()
                    require('nvim-navbuddy').open()
                end,
                desc = '󰱼 Open LSP symbol tree',
            },
        },
    },
}
