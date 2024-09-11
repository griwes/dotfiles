return {
    {
        'LeonHeidelbach/trailblazer.nvim',
        event = 'VeryLazy',
        opts = {
            auto_save_trailblazer_state_on_exit = true,
            auto_load_trailblazer_state_on_enter = true,
            trail_options = {
                trail_mark_list_rows = 25,
                mark_symbol = ' ',
                newest_mark_symbol = '󰳠 ',
                cursor_mark_symbol = ' ',
                next_mark_symbol = '󰧂󰟙',
                previous_mark_symbol = '󰟙󰧀',
                multiple_mark_symbol_counters_enabled = false,
                trail_mark_symbol_line_indicators_enabled = true,
                current_trail_mark_stack_sort_mode = 'chron_dsc',
                move_to_nearest_before_peek = true,
                move_to_nearest_before_peek_motion_directive_up = 'up',
                move_to_nearest_before_peek_motion_directive_down = 'down',
            },
            force_mappings = {
                i = {
                    motions = {
                        peek_move_next_down = '<A-k>',
                        peek_move_previous_up = '<A-l>',
                        move_to_nearest = '<A-e>',
                        move_to_trail_mark_cursor = '<A-q>',
                    },
                    actions = {
                        new_trail_mark = '<A-t>',
                    }
                },
                nv = {
                    motions = {
                        peek_move_next_down = '<A-k>',
                        peek_move_previous_up = '<A-l>',
                        move_to_nearest = '<A-e>',
                        move_to_trail_mark_cursor = '<A-q>',
                    },
                    actions = {
                        new_trail_mark = '<A-t>',
                        track_back = '<A-r>',
                        toggle_trail_mark_list = '<A-m>',
                        delete_all_trail_marks = '<C-A-x>',
                        delete_trail_mark_stack = '<C-S-A-x>',
                        delete_all_trail_mark_stacks = '<leader><C-S-A-x>',
                        set_trail_mark_select_mode = '<A-d>',
                    }
                }
            },
            quickfix_mappings = {
                v = {
                    actions = {
                        qf_action_move_selected_trail_marks_down = '<A-k>',
                        qf_action_move_selected_trail_marks_up = '<A-l>',
                    }
                },
            }
        },
        keys = {
            {
                '<A-f>',
                function()
                    vim.ui.select(require('trailblazer.trails.stacks').get_sorted_stack_names(),
                        { prompt = 'Select trailblazer stack:', },
                        function(choice) vim.fn.require('trailblazer').switch_trail_mark_stack(choice) end)
                end,
                desc = 'Select trailblazer stack'
            },
            {
                '<A-n>',
                function()
                    vim.ui.input_nui({ prompt = 'Name for the new trailblazer stack:' },
                        function(name) require('trailblazer').add_trail_mark_stack(name) end)
                end,
                desc = 'Create new trailblazer stack'
            },
        }
    }
}
