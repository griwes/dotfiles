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
            force_mappings = {},
            quickfix_mappings = {
                v = {
                    actions = {
                        qf_action_move_selected_trail_marks_down = '<A-k>',
                        qf_action_move_selected_trail_marks_up = '<A-l>',
                    },
                },
            },
        },
        keys = {
            {
                '<A-k>',
                function()
                    require('trailblazer').peek_move_next_down()
                end,
                mode = { 'n', 'x', 'i' },
                desc = ' Next trail mark',
            },
            {
                '<A-l>',
                function()
                    require('trailblazer').peek_move_previous_up()
                end,
                mode = { 'n', 'x', 'i' },
                desc = ' Previous trail mark',
            },
            {
                '<A-e>',
                function()
                    require('trailblazer').move_to_nearest()
                end,
                mode = { 'n', 'x', 'i' },
                desc = ' Nearest trail mark',
            },
            {
                '<A-q>',
                function()
                    require('trailblazer').move_to_trail_mark_cursor()
                end,
                mode = { 'n', 'x', 'i' },
                desc = ' Trail mark cursor',
            },
            {
                '<A-t>',
                function()
                    require('trailblazer').new_trail_mark()
                end,
                mode = { 'n', 'x', 'i' },
                desc = ' Add trail mark',
            },
            {
                '<A-r>',
                function()
                    require('trailblazer').track_back()
                end,
                mode = { 'n', 'x' },
                desc = ' Track back',
            },
            {
                '<A-m>',
                function()
                    require('trailblazer').toggle_trail_mark_list()
                end,
                mode = { 'n', 'x' },
                desc = ' Toggle trail mark list',
            },
            {
                '<A-d>',
                function()
                    require('trailblazer').set_trail_mark_select_mode()
                end,
                mode = { 'n', 'x' },
                desc = ' Select trail mark mode',
            },
            {
                '<A-.>',
                function()
                    require('trailblazer').switch_to_next_trail_mark_stack()
                end,
                mode = { 'n', 'x' },
                desc = ' Next trail mark stack',
            },
            {
                '<A-,>',
                function()
                    require('trailblazer').switch_to_previous_trail_mark_stack()
                end,
                mode = { 'n', 'x' },
                desc = ' Previous trail mark stack',
            },
            {
                '<A-x>',
                function()
                    require('trailblazer').delete_all_trail_marks()
                end,
                mode = { 'n', 'x' },
                desc = ' Delete trail marks in stack',
            },
            {
                '<A-X>',
                function()
                    require('trailblazer').delete_trail_mark_stack()
                end,
                mode = { 'n', 'x' },
                desc = ' Delete trail mark stack',
            },
            {
                '<C-A-X>',
                function()
                    require('trailblazer').delete_all_trail_mark_stacks()
                end,
                mode = { 'n', 'x' },
                desc = ' Delete all trail mark stacks',
            },
            {
                '<A-f>',
                function()
                    vim.ui.select(
                        require('trailblazer.trails.stacks').get_sorted_stack_names(),
                        { prompt = 'Select trailblazer stack:' },
                        function(choice)
                            require('trailblazer').switch_trail_mark_stack(choice)
                        end
                    )
                end,
                desc = ' Select trailblazer stack',
            },
            {
                '<A-n>',
                function()
                    vim.ui.input_nui({ prompt = 'Name for the new trailblazer stack:' }, function(name)
                        require('trailblazer').add_trail_mark_stack(name)
                    end)
                end,
                desc = ' Create new trailblazer stack',
            },
        },
    },
}
