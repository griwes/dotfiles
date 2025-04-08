return {
    {
        'SuperBo/fugit2.nvim',
        lazy = false,
        opts = {
            libgit2_path = '/usr/lib/x86_64-linux-gnu/libgit2.so',
        },
        keys = {
            { '<leader>gf', '<cmd>Fugit2<cr>' },
        },
    },
    {
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'sindrets/diffview.nvim',
        },
        opts = function()
            -- monkey-patch, because these are not configurable...
            local neogit_buffer = require('neogit.lib.buffer')
            local original_fn = neogit_buffer.create
            neogit_buffer.create = function(config)
                if config.filetype == 'NeogitLogView' then
                    config.mappings.n.l = config.mappings.n.k
                    config.mappings.n.k = config.mappings.n.j
                    config.mappings.n.j = nil
                end
                return original_fn(config)
            end

            return {
                disable_hint = false,
                disable_context_highlighting = true,
                graph_style = 'unicode',
                telescope_sorter = function()
                    return require('telescope').extensions.fzf.native_fzf_sorter()
                end,
                integrations = {
                    telescope = true,
                    diffview = true,
                    fzf_lua = false,
                },
                mappings = {
                    commit_editor = {
                        ['q'] = 'Close',
                        ['<c-c><c-c>'] = 'Submit',
                        ['<c-c><c-k>'] = 'Abort',
                    },
                    rebase_editor = {
                        ['p'] = 'Pick',
                        ['r'] = 'Reword',
                        ['e'] = 'Edit',
                        ['s'] = 'Squash',
                        ['f'] = 'Fixup',
                        ['x'] = 'Execute',
                        ['d'] = 'Drop',
                        ['b'] = 'Break',
                        ['q'] = 'Close',
                        ['<cr>'] = 'OpenCommit',
                        ['j'] = false,
                        ['l'] = 'MoveUp',
                        ['k'] = 'MoveDown',
                        ['gj'] = false,
                        ['gl'] = 'MoveUp',
                        ['gk'] = 'MoveDown',
                        ['<c-c><c-c>'] = 'Submit',
                        ['<c-c><c-k>'] = 'Abort',
                    },
                    finder = {
                        ['<cr>'] = 'Select',
                        ['<c-c>'] = 'Close',
                        ['<esc>'] = 'Close',
                        ['<c-n>'] = 'Next',
                        ['<c-p>'] = 'Previous',
                        ['<down>'] = 'Next',
                        ['<up>'] = 'Previous',
                        ['<tab>'] = 'MultiselectToggleNext',
                        ['<s-tab>'] = 'MultiselectTogglePrevious',
                        ['<c-j>'] = 'NOP',
                    },
                    popup = {
                        ['?'] = 'HelpPopup',
                        ['er'] = 'RemotePopup',
                        ['d'] = 'DiffPopup',
                        ['ex'] = 'ResetPopup',
                        ['es'] = 'StashPopup',
                        ['c'] = 'CommitPopup',
                        ['b'] = 'BranchPopup',
                        ['t'] = 'TagPopup',
                        ['h'] = 'LogPopup',
                        ['f'] = 'FetchPopup',
                        ['p'] = 'PullPopup',
                        ['ep'] = 'PushPopup',
                        ['m'] = 'MergePopup',
                        ['r'] = 'RebasePopup',
                        ['ec'] = 'CherryPickPopup',
                        ['eu'] = 'RevertPopup',
                        ['i'] = 'IgnorePopup',
                        ['ew'] = 'WorktreePopup',

                        ['A'] = false,
                        ['Z'] = false,
                        ['v'] = false,
                        ['w'] = false,
                        ['X'] = false,
                        ['l'] = false,
                        ['M'] = false,
                        ['P'] = false,
                    },
                    status = {
                        ['q'] = 'Close',
                        ['I'] = 'InitRepo',
                        ['1'] = 'Depth1',
                        ['2'] = 'Depth2',
                        ['3'] = 'Depth3',
                        ['4'] = 'Depth4',
                        ['<tab>'] = 'Toggle',
                        ['x'] = 'Discard',
                        ['s'] = 'Stage',
                        ['S'] = 'StageUnstaged',
                        ['<c-s>'] = false,
                        ['u'] = 'Unstage',
                        ['U'] = 'UnstageStaged',
                        ['$'] = 'CommandHistory',
                        ['Y'] = 'YankSelected',
                        ['<c-r>'] = 'RefreshBuffer',
                        ['<enter>'] = 'GoToFile',
                        ['<c-v>'] = 'VSplitOpen',
                        ['<c-x>'] = 'SplitOpen',
                        ['<c-t>'] = 'TabOpen',
                        ['{'] = 'GoToPreviousHunkHeader',
                        ['}'] = 'GoToNextHunkHeader',
                        ['j'] = false,
                        ['l'] = 'MoveUp',
                        ['k'] = 'MoveDown',
                        ['gj'] = false,
                        ['gl'] = 'MoveUp',
                        ['gk'] = 'MoveDown',
                        ['<C-j>'] = false,
                        ['<C-l>'] = 'PeekUp',
                        ['<C-k>'] = 'PeekDown',
                    },
                }
            }
        end,
        cmds = {
            'Neogit',
        },
        keys = {
            { '<leader>gg', '<cmd>Neogit<cr>', 'Open Neogit' },
        }
    }
}
