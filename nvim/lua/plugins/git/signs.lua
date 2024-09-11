return {
    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        config = function()
            local gs = require('gitsigns')

            gs.setup({
                numhl = true,
                signcolumn = true,
                attach_to_untracked = false,
                preview_config = {
                    border = 'rounded',
                },
                current_line_blame_opts = {
                    virt_text_pos = 'right_align',
                    delay = 100,
                },
            })

            local wk = require('which-key')

            wk.add({
                { '<leader>gsb', gs.toggle_current_line_blame, desc = 'Toggle current line blame' },
                { '<leader>gsB', gs.show,                      desc = 'Show file base' },
                {
                    '<leader>gsd',
                    function()
                        gs.toggle_deleted(); gs.toggle_linehl(); gs.toggle_word_diff()
                    end,
                    desc = 'Toggle diff-like display'
                },
                { '<leader>gsD', gs.toggle_deleted,                             desc = 'Toggle display of deleted lines' },
                { '<leader>gB',  function() gs.blame_line({ full = true }) end, desc = 'Show full line blame' },
                { '<leader>gd',  '<cmd>DiffviewOpen<cr>',                       desc = 'Open diffview' },
                { '<leader>hs',  gs.stage_hunk,                                 desc = 'Stage current hunk' },
                { '<leader>hr',  gs.reset_hunk,                                 desc = 'Reset current hunk' },
                { '<leader>hu',  gs.undo_stage_hunk,                            desc = 'Undo stage hunk' },
                { '<leader>hp',  gs.preview_hunk,                               desc = 'Preview current hunk' },
                { '<leader>hS',  gs.stage_buffer,                               desc = 'Stage the buffer' },
                { '<leader>hR',  gs.reset_buffer,                               desc = 'Reset the buffer' },
                { '<leader>hU',  gs.reset_buffer_index,                         desc = 'Unstage the buffer' },
            })

            wk.add({
                { '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Stage selection', mode = 'v' },
                { '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, desc = 'Reset selection', mode = 'v' } });

            vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
        end,
    },
}
