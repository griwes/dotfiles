return {
    {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'nvim-tree/nvim-web-devicons',
        },
        review_diff = {
            add_review_comment = { lhs = '<leader>ca', desc = 'Add a new review comment' },
            add_review_suggestion = { lhs = '<leader>sa', desc = 'Add a new review suggestion' },
        },
        opts = {
            use_local_fs = true,
            enable_builtin = true,
            picker = 'telescope',
            picker_config = {
                use_emojis = false,
                mappings = {
                    open_in_browser = { lhs = '<C-b>', desc = 'Open issue in browser' },
                    copy_url = { lhs = '<C-y>', desc = 'Copy url to system clipboard' },
                    checkout_pr = { lhs = '<C-o>', desc = 'Checkout pull request' },
                    merge_pr = { lhs = '<C-m>', desc = 'Merge pull request' },
                },
            },
            comment_icon = '▎', -- comment marker
            outdated_icon = '󰅒 ', -- outdated indicator
            resolved_icon = ' ', -- resolved indicator
            reaction_viewer_hint_icon = ' ', -- marker for user reactions
            user_icon = ' ', -- user icon
            timeline_marker = ' ', -- timeline marker
            timeline_indent = '2', -- timeline indentation
            right_bubble_delimiter = '', -- bubble delimiter
            left_bubble_delimiter = '', -- bubble delimiter
            default_to_projects_v2 = true,
            issues = {
                order_by = {
                    field = 'UPDATED_AT',
                    direction = 'DESC',
                },
            },
            pull_requests = {
                order_by = {
                    field = 'UPDATED_AT',
                    direction = 'DESC',
                },
                always_select_remote_on_create = false,
            },
            file_panel = {
                size = 12,
                use_icons = true,
            },
            mappings = {
                issue = {
                    close_issue = { lhs = '<leader>ic', desc = 'Close issue' },
                    reopen_issue = { lhs = '<leader>io', desc = 'Reopen issue' },
                    list_issues = { lhs = '<leader>il', desc = 'List open issues on same repo' },
                    reload = { lhs = '<C-r>', desc = 'Reload issue' },
                    open_in_browser = { lhs = '<C-b>', desc = 'Open issue in browser' },
                    copy_url = { lhs = '<C-y>', desc = 'Copy url to system clipboard' },
                    add_assignee = { lhs = '<leader>aa', desc = 'Add assignee' },
                    remove_assignee = { lhs = '<leader>ad', desc = 'Remove assignee' },
                    create_label = { lhs = '<leader>lc', desc = 'Create label' },
                    add_label = { lhs = '<leader>la', desc = 'Add label' },
                    remove_label = { lhs = '<leader>ld', desc = 'Remove label' },
                    goto_issue = { lhs = '<leader>gi', desc = 'Navigate to a local repo issue' },
                    add_comment = { lhs = '<leader>ca', desc = 'Add comment' },
                    delete_comment = { lhs = '<leader>cd', desc = 'Delete comment' },
                    next_comment = { lhs = ']c', desc = 'Go to next comment' },
                    prev_comment = { lhs = '[c', desc = 'Go to previous comment' },
                    react_hooray = { lhs = '<leader>ep', desc = 'Add/remove 🎉 reaction' },
                    react_heart = { lhs = '<leader>eh', desc = 'Add/remove ❤️ reaction' },
                    react_eyes = { lhs = '<leader>ee', desc = 'Add/remove 👀 reaction' },
                    react_thumbs_up = { lhs = '<leader>e+', desc = 'Add/remove 👍 reaction' },
                    react_thumbs_down = { lhs = '<leader>e-', desc = 'Add/remove 👎 reaction' },
                    react_rocket = { lhs = '<leader>er', desc = 'Add/remove 🚀 reaction' },
                    react_laugh = { lhs = '<leader>el', desc = 'Add/remove 😄 reaction' },
                    react_confused = { lhs = '<leader>ec', desc = 'Add/remove 😕 reaction' },
                },
                pull_request = {
                    checkout_pr = { lhs = '<leader>po', desc = 'Checkout PR' },
                    merge_pr = { lhs = '<leader>pmm', desc = 'Merge commit PR' },
                    squash_and_merge_pr = { lhs = '<leader>pms', desc = 'Squash and merge PR' },
                    rebase_and_merge_pr = { lhs = '<leader>pmr', desc = 'Rebase and merge PR' },
                    list_commits = { lhs = '<leader>pc', desc = 'List PR commits' },
                    list_changed_files = { lhs = '<leader>pf', desc = 'List PR changed files' },
                    show_pr_diff = { lhs = '<leader>pd', desc = 'Show PR diff' },
                    add_reviewer = { lhs = '<leader>ra', desc = 'Add reviewer' },
                    remove_reviewer = { lhs = '<leader>rd', desc = 'Remove reviewer request' },
                    close_issue = { lhs = '<leader>ic', desc = 'Close PR' },
                    reopen_issue = { lhs = '<leader>io', desc = 'Reopen PR' },
                    list_issues = { lhs = '<leader>il', desc = 'List open issues on same repo' },
                    reload = { lhs = '<C-r>', desc = 'Reload PR' },
                    open_in_browser = { lhs = '<C-b>', desc = 'Open PR in browser' },
                    copy_url = { lhs = '<C-y>', desc = 'Copy url to system clipboard' },
                    goto_file = { lhs = 'gf', desc = 'Go to file' },
                    add_assignee = { lhs = '<leader>aa', desc = 'Add assignee' },
                    remove_assignee = { lhs = '<leader>ad', desc = 'Remove assignee' },
                    create_label = { lhs = '<leader>lc', desc = 'Create label' },
                    add_label = { lhs = '<leader>la', desc = 'Add label' },
                    remove_label = { lhs = '<leader>ld', desc = 'Remove label' },
                    goto_issue = { lhs = '<leader>gi', desc = 'Navigate to a local repo issue' },
                    add_comment = { lhs = '<leader>ca', desc = 'Add comment' },
                    delete_comment = { lhs = '<leader>cd', desc = 'Delete comment' },
                    next_comment = { lhs = ']c', desc = 'Go to next comment' },
                    prev_comment = { lhs = '[c', desc = 'Go to previous comment' },
                    react_hooray = { lhs = '<leader>ep', desc = 'Add/remove 🎉 reaction' },
                    react_heart = { lhs = '<leader>eh', desc = 'Add/remove ❤️ reaction' },
                    react_eyes = { lhs = '<leader>ee', desc = 'Add/remove 👀 reaction' },
                    react_thumbs_up = { lhs = '<leader>e+', desc = 'Add/remove 👍 reaction' },
                    react_thumbs_down = { lhs = '<leader>e-', desc = 'Add/remove 👎 reaction' },
                    react_rocket = { lhs = '<leader>er', desc = 'Add/remove 🚀 reaction' },
                    react_laugh = { lhs = '<leader>el', desc = 'Add/remove 😄 reaction' },
                    react_confused = { lhs = '<leader>ec', desc = 'Add/remove 😕 reaction' },
                },
                review_thread = {
                    goto_issue = { lhs = '<leader>gi', desc = 'Navigate to a local repo issue' },
                    add_comment = { lhs = '<leader>ca', desc = 'Add comment' },
                    add_suggestion = { lhs = '<leader>cs', desc = 'Add suggestion' },
                    delete_comment = { lhs = '<leader>cd', desc = 'Delete comment' },
                    next_comment = { lhs = ']c', desc = 'Go to next comment' },
                    prev_comment = { lhs = '[c', desc = 'Go to previous comment' },
                    select_next_entry = { lhs = ']q', desc = 'Move to previous changed file' },
                    select_prev_entry = { lhs = '[q', desc = 'Move to next changed file' },
                    select_first_entry = { lhs = '[Q', desc = 'Move to first changed file' },
                    select_last_entry = { lhs = ']Q', desc = 'Move to last changed file' },
                    close_review_tab = { lhs = 'q', desc = 'Close review tab' },
                    react_hooray = { lhs = '<leader>ep', desc = 'Add/remove 🎉 reaction' },
                    react_heart = { lhs = '<leader>eh', desc = 'Add/remove ❤️ reaction' },
                    react_eyes = { lhs = '<leader>ee', desc = 'Add/remove 👀 reaction' },
                    react_thumbs_up = { lhs = '<leader>e+', desc = 'Add/remove 👍 reaction' },
                    react_thumbs_down = { lhs = '<leader>e-', desc = 'Add/remove 👎 reaction' },
                    react_rocket = { lhs = '<leader>er', desc = 'Add/remove 🚀 reaction' },
                    react_laugh = { lhs = '<leader>el', desc = 'Add/remove 😄 reaction' },
                    react_confused = { lhs = '<leader>ec', desc = 'Add/remove 😕 reaction' },
                },
                submit_win = {
                    approve_review = { lhs = '<C-a>', desc = 'Approve review' },
                    comment_review = { lhs = '<C-m>', desc = 'Comment review' },
                    request_changes = { lhs = '<C-r>', desc = 'Request changes review' },
                    close_review_tab = { lhs = 'q', desc = 'Close review tab' },
                },
                review_diff = {
                    add_review_comment = { lhs = '<leader>ca', desc = 'Add a new review comment' },
                    add_review_suggestion = { lhs = '<leader>cs', desc = 'Add a new review suggestion' },
                    focus_files = { lhs = '<leader>f', desc = 'Move focus to changed file panel' },
                    toggle_files = { lhs = '<leader>F', desc = 'Hide/show changed files panel' },
                    next_thread = { lhs = ']t', desc = 'Move to next thread' },
                    prev_thread = { lhs = '[t', desc = 'Move to previous thread' },
                    select_next_entry = { lhs = ']q', desc = 'Move to previous changed file' },
                    select_prev_entry = { lhs = '[q', desc = 'Move to next changed file' },
                    select_first_entry = { lhs = '[Q', desc = 'Move to first changed file' },
                    select_last_entry = { lhs = ']Q', desc = 'Move to last changed file' },
                    close_review_tab = { lhs = 'q', desc = 'Close review tab' },
                    toggle_viewed = { lhs = '<leader><space>', desc = 'Toggle viewer viewed state' },
                    goto_file = { lhs = 'gf', desc = 'Go to file' },
                },
                file_panel = {
                    next_entry = { lhs = 'k', desc = 'Move to next changed file' },
                    prev_entry = { lhs = 'l', desc = 'Move to previous changed file' },
                    select_entry = { lhs = '<cr>', desc = 'Show selected changed file diffs' },
                    refresh_files = { lhs = '<C-r>', desc = 'Refresh changed files panel' },
                    focus_files = { lhs = '<leader>f', desc = 'Move focus to changed file panel' },
                    toggle_files = { lhs = '<leader>F', desc = 'Hide/show changed files panel' },
                    select_next_entry = { lhs = ']q', desc = 'Move to previous changed file' },
                    select_prev_entry = { lhs = '[q', desc = 'Move to next changed file' },
                    select_first_entry = { lhs = '[Q', desc = 'Move to first changed file' },
                    select_last_entry = { lhs = ']Q', desc = 'Move to last changed file' },
                    close_review_tab = { lhs = 'q', desc = 'Close review tab' },
                    toggle_viewed = { lhs = '<leader><space>', desc = 'Toggle viewer viewed state' },
                },
            },
        },
        cmds = {
            'Octo',
        },
        keys = {
            { '<leader>oo', '<cmd>Octo<cr>', desc = 'Search all possible Octo actions' },

            { '<leader>oil', '<cmd>Octo issue list<cr>', desc = 'List issues for the current repo' },
            { '<leader>oim', '<cmd>Octo issue search assignee:griwes status:open<cr>',
                desc = 'List issues assigned to me in the current repo' },
            { '<leader>oic', '<cmd>Octo issue create<cr>', desc = 'Create an issue against the current repo' },

            { '<leader>opl', '<cmd>Octo pr list<cr>', desc = 'List PRs for the current repo' },
            { '<leader>opm', '<cmd>Ocro pr search author:griwes status:open<cr>',
                desc = 'List my open PRs in the current repo' },
            { '<leader>opr', '<cmd>Octo pr search review:required user-review-requested:griwes state:open<cr>',
                desc = 'List open PRs awaiting my review in this repo' },
            { '<leader>opc', '<cmd>Octo pr create<cr>', desc = 'Open a PR from the current branch' },

            { '<leader>ors', '<cmd>Octo review start<cr>', desc = 'Start a review' },
            { '<leader>orr', '<cmd>Octo review resume<cr>', desc = 'Resume a review' },
            { '<leader>ord', '<cmd>Octo review discard<cr>', desc = 'Discard the review' },
            { '<leader>orc', '<cmd>Octo review commit<cr>', desc = 'Choose commit to review' },
            { '<leader>or<cr>', '<cmd>Octo review submit<cr>', desc = 'Submit the review' },

            { '<leader>otr', '<cmd>Octo thread resolve', desc = 'Resolve current thread' },
            { '<leader>otu', '<cmd>Octo thread unresolve', desc = 'Unresolve current thread' },
        },
    },
}
