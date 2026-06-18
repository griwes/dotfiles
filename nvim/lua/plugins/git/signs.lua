local function vgit(method)
    return function()
        require('vgit')[method]()
    end
end

return {
    {
        'tanvirtin/vgit.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            'NeogitOrg/neogit',
        },
        event = 'VeryLazy',
        -- branch = "develop",
        config = function()
            local vg = require('vgit')

            vg.setup({
                keymaps = {},
                settings = {
                    live_blame = {
                        enabled = false,
                    },
                },
            })

            require('utils.bracket_nav').map('h', {
                mode = { 'n', 'x', 'o' },
                icon = ' ',
                desc = 'hunk',
                next = function()
                    require('vgit').hunk_down()
                end,
                prev = function()
                    require('vgit').hunk_up()
                end,
            })
        end,
        keys = {
            { 'hgs', vgit('buffer_hunk_stage'), desc = ' Stage hunk' },
            { 'hgu', vgit('buffer_hunk_reset'), desc = ' Reset hunk' },
            { 'hgp', vgit('buffer_hunk_preview'), desc = ' Preview hunk' },
            { 'hgD', vgit('buffer_diff_preview'), desc = ' Preview diff' },
            { 'hgS', vgit('buffer_stage'), desc = ' Stage buffer' },
            { 'hgU', vgit('buffer_unstage'), desc = ' Unstage buffer' },
            { 'hgR', vgit('buffer_reset'), desc = ' Reset buffer' },
            { 'hgh', vgit('buffer_history_preview'), desc = ' Preview history' },
            { 'hgP', vgit('project_diff_preview'), desc = ' Preview project diff' }, -- FIXME: this has issues, is it difftastic?

            { 'hgd', vgit('toggle_diff_preference'), desc = ' Switch side-by-side/unified' },
            { 'hgb', vgit('toggle_live_blame'), desc = ' Toggle blame' },
            { 'hgt', vgit('toggle_live_gutter'), desc = ' Toggle gutter' },

            { 'hcc', vgit('buffer_conflict_accept_current'), desc = ' Accept current' },
            { 'hci', vgit('buffer_conflict_accept_incoming'), desc = ' Accept incoming' },
            { 'hcb', vgit('buffer_conflict_accept_both'), desc = ' Accept both' },
        },
    },
}
