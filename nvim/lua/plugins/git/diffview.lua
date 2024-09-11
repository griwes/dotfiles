return {
    {
        'sindrets/diffview.nvim',
        event = 'VeryLazy',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        config = function(_, opts)
            local actions = require('diffview.actions')

            opts.keymaps = {
                disable_defaults = true,
                view = {
                    -- The `view` bindings are active in the diff buffers, only when the current
                    -- tabpage is a Diffview.
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { 'n', ']q', actions.select_next_entry, { desc = 'Open the diff for the next file' }, },
                    { 'n', '[q', actions.select_prev_entry, { desc = 'Open the diff for the previous file' }, },
                    { 'n', '<leader>T', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' }, },
                    { 'n', '<leader>t', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' }, },
                    { 'n', '<leader>f', actions.focus_files, { desc = 'Bring focus to the file panel' }, },
                    { 'n', '<leader>F', actions.toggle_files, { desc = 'Toggle the file panel.' }, },
                    { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle through available layouts.' }, },
                    { 'n', '[x', actions.prev_conflict, { desc = 'Jump to the previous conflict' }, },
                    { 'n', ']x', actions.next_conflict, { desc = 'Jump to the next conflict' }, },
                    { 'n', '<leader>co', actions.conflict_choose('ours'), { desc = 'Conflict: OURS' }, },
                    { 'n', '<leader>ct', actions.conflict_choose('theirs'), { desc = 'Conflict: THEIRS' }, },
                    { 'n', '<leader>cb', actions.conflict_choose('base'), { desc = 'Conflict: BASE' }, },
                    { 'n', '<leader>ca', actions.conflict_choose('all'), { desc = 'Conflict: all' }, },
                    { 'n', 'dx', actions.conflict_choose('none'), { desc = 'Delete the conflict region' }, },
                    { 'n', '<leader>cO', actions.conflict_choose_all('ours'), { desc = 'File: OURS' }, },
                    { 'n', '<leader>cT', actions.conflict_choose_all('theirs'), { desc = 'File: THEIRS' }, },
                    { 'n', '<leader>cB', actions.conflict_choose_all('base'), { desc = 'File: BASE' }, },
                    { 'n', '<leader>cA', actions.conflict_choose_all('all'), { desc = 'File: all versions' }, },
                    { 'n', 'dX', actions.conflict_choose_all('none'), { desc = 'Delete all conflict regions' }, },
                },
                diff1 = {
                    -- Mappings in single window diff layouts
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { 'n', 'g?', actions.help({ 'view', 'diff1' }), { desc = 'Open the help panel' }, },
                },
                diff2 = {
                    -- Mappings in 2-way diff layouts
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { 'n', 'g?', actions.help({ 'view', 'diff2' }), { desc = 'Open the help panel' }, },
                },
                diff3 = {
                    -- Mappings in 3-way diff layouts
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { { 'n', 'x' }, '2do', actions.diffget('ours'), { desc = 'Obtain hunk: OURS' }, },
                    { { 'n', 'x' }, '3do', actions.diffget('theirs'), { desc = 'Obtain hunk: THEIRS' }, },
                    { 'n', 'g?', actions.help({ 'view', 'diff3' }), { desc = 'Open the help panel' }, },
                },
                diff4 = {
                    -- Mappings in 4-way diff layouts
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { { 'n', 'x' }, '1do', actions.diffget('base'), { desc = 'Obtain hunk: BASE' }, },
                    { { 'n', 'x' }, '2do', actions.diffget('ours'), { desc = 'Obtain hunk: OURS' }, },
                    { { 'n', 'x' }, '3do', actions.diffget('theirs'), { desc = 'Obtain hunk: THEIRS' }, },
                    { 'n', 'g?', actions.help({ 'view', 'diff4' }), { desc = 'Open the help panel' }, },
                },
                file_panel = {
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { 'n', 'k', actions.next_entry, { desc = 'Bring the cursor to the next file entry' }, },
                    { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' }, },
                    { 'n', 'l', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' }, },
                    { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry' }, },
                    { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry' }, },
                    { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' }, },
                    { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry' }, },
                    { 'n', 's', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry' }, },
                    { 'n', 'S', actions.stage_all, { desc = 'Stage all entries' }, },
                    { 'n', 'U', actions.unstage_all, { desc = 'Unstage all entries' }, },
                    { 'n', 'X', actions.restore_entry, { desc = 'Restore entry to the state on the left side' }, },
                    { 'n', 'h', actions.open_commit_log, { desc = 'Open the commit log panel' }, },
                    { 'n', ';', actions.open_fold, { desc = 'Expand fold' }, },
                    { 'n', 'zo', actions.open_fold, { desc = 'Expand fold' }, },
                    { 'n', 'j', actions.close_fold, { desc = 'Collapse fold' }, },
                    { 'n', 'zc', actions.close_fold, { desc = 'Collapse fold' }, },
                    { 'n', 'za', actions.toggle_fold, { desc = 'Toggle fold' }, },
                    { 'n', 'zR', actions.open_all_folds, { desc = 'Expand all folds' }, },
                    { 'n', 'zM', actions.close_all_folds, { desc = 'Collapse all folds' }, },
                    { 'n', '<c-s>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' }, },
                    { 'n', '<c-d>', actions.scroll_view(0.25), { desc = 'Scroll the view down' }, },
                    { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' }, },
                    { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' }, },
                    { 'n', '<leader>T', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' }, },
                    { 'n', '<leader>t', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' }, },
                    { 'n', 'i', actions.listing_style, { desc = 'Toggle between "list" and "tree" views' }, },
                    { 'n', 'f', actions.toggle_flatten_dirs, { desc = 'Toggle flattening of empty subdirectories' }, },
                    { 'n', '<c-r>', actions.refresh_files, { desc = 'Update stats and entries in the file list' }, },
                    { 'n', '<leader>f', actions.focus_files, { desc = 'Bring focus to the file panel' }, },
                    { 'n', '<leader>F', actions.toggle_files, { desc = 'Toggle the file panel' }, },
                    { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle available layouts' }, },
                    { 'n', '[x', actions.prev_conflict, { desc = 'Go to the previous conflict' }, },
                    { 'n', ']x', actions.next_conflict, { desc = 'Go to the next conflict' }, },
                    { 'n', 'g?', actions.help('file_panel'), { desc = 'Open the help panel' }, },
                    { 'n', '<leader>cO', actions.conflict_choose_all('ours'), { desc = 'File: OURS' }, },
                    { 'n', '<leader>cT', actions.conflict_choose_all('theirs'), { desc = 'File: THEIRS' }, },
                    { 'n', '<leader>cB', actions.conflict_choose_all('base'), { desc = 'File: BASE' }, },
                    { 'n', '<leader>cA', actions.conflict_choose_all('all'), { desc = 'File: all versions' }, },
                    { 'n', 'dX', actions.conflict_choose_all('none'), { desc = 'Delete all conflict regions' }, },
                },
                file_history_panel = {
                    { 'n', 'q', actions.close, { desc = 'Close diffview' }, },
                    { 'n', 'g!', actions.options, { desc = 'Open the option panel' }, },
                    { 'n', 'y', actions.copy_hash, { desc = 'Copy the commit hash of the entry under the cursor' }, },
                    { 'n', ';', actions.open_commit_log, { desc = 'Show commit details' }, },
                    { 'n', 'zR', actions.open_all_folds, { desc = 'Expand all folds' }, },
                    { 'n', 'zM', actions.close_all_folds, { desc = 'Collapse all folds' }, },
                    { 'n', 'k', actions.next_entry, { desc = 'Bring the cursor to the next file entry' }, },
                    { 'n', '<down>', actions.next_entry, { desc = 'Bring the cursor to the next file entry' }, },
                    { 'n', 'l', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry.' }, },
                    { 'n', '<up>', actions.prev_entry, { desc = 'Bring the cursor to the previous file entry.' }, },
                    { 'n', '<cr>', actions.select_entry, { desc = 'Open the diff for the selected entry.' }, },
                    { 'n', '<2-LeftMouse>', actions.select_entry, { desc = 'Open the diff for the selected entry.' }, },
                    { 'n', 'o', actions.select_entry, { desc = 'Open the diff for the selected entry' }, },
                    { 'n', '<c-s>', actions.scroll_view(-0.25), { desc = 'Scroll the view up' }, },
                    { 'n', '<c-d>', actions.scroll_view(0.25), { desc = 'Scroll the view down' }, },
                    { 'n', '<tab>', actions.select_next_entry, { desc = 'Open the diff for the next file' }, },
                    { 'n', '<s-tab>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' }, },
                    { 'n', '<leader>T', actions.goto_file_edit, { desc = 'Open the file in the previous tabpage' }, },
                    { 'n', '<leader>t', actions.goto_file_tab, { desc = 'Open the file in a new tabpage' }, },
                    { 'n', '<leader>f', actions.focus_files, { desc = 'Bring focus to the file panel' }, },
                    { 'n', '<leader>F', actions.toggle_files, { desc = 'Toggle the file panel' }, },
                    { 'n', 'g<C-x>', actions.cycle_layout, { desc = 'Cycle available layouts' }, },
                    { 'n', 'g?', actions.help('file_history_panel'), { desc = 'Open the help panel' }, },
                },
                option_panel = {
                    { 'n', '<tab>', actions.select_entry, { desc = 'Change the current option' }, },
                    { 'n', 'q', actions.close, { desc = 'Close the panel' }, },
                    { 'n', 'g?', actions.help('option_panel'), { desc = 'Open the help panel' }, },
                },
                help_panel = {
                    { 'n', 'q', actions.close, { desc = 'Close help menu' }, },
                    { 'n', '<esc>', actions.close, { desc = 'Close help menu' }, },
                },
            }

            require('diffview').setup(opts)
        end,
        opts = {
            enhanced_diff_hl = true,
            view = {
                merge_tool = {
                    layout = 'diff4_mixed',
                },
            },
            file_panel = {
                win_config = {
                    width = 45,
                },
            },
            keymaps = {
                disable_defaults = true,
            },
        },
    },
}
