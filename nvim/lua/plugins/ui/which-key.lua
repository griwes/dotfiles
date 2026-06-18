local diagnostics = require('utils.diagnostics')

-- Key family policy and WhichKey group registry.
--
-- Leaf mappings stay with the feature/plugin that owns the behavior. This table
-- is the one central documentation point for prefix ownership:
--
-- * `g*` is for actions, jumps, and immediate movement.
-- * `h*` is for previews, UI surfaces, toggles, and less-classified actions.
-- * `gl*` performs LSP actions; `hl*` previews LSP locations/results.
-- * `gj*` opens immediate labelled menus, mostly Snipe-backed.
-- * `hd*` is dedicated to diagnostics.
-- * `gm*` / `gs*` are structural move/swap families.
-- * `[ ]` are repeatable previous/next navigation families.
-- * Textobject families use `a*` for around and `i*` for inside.
local keymap_family_spec = {
    {
        mode = { 'n', 'x', 'o' },
        { 'g', group = 'Actions and jumps', icon = '󰁔 ' },
        { 'ga', group = 'Text case', icon = '󰬴 ' },
        { 'gc', group = 'Comments', icon = '󰅺 ' },
        { 'gd', group = 'Debug actions', icon = ' ' },
        { 'gj', group = 'Labelled quick menus', icon = '󰱼 ' },
        { 'gl', group = 'LSP actions', icon = ' ' },
        { 'gm', group = 'Structural moves', icon = '󰁔 ' },
        { 'gs', group = 'Structural swaps', icon = '󰓡 ' },
    },
    {
        mode = { 'n', 'x' },
        { 'gx', desc = 'Open URI', icon = '󰖟 ' },
    },
    {
        mode = 'n',
        { 'gC', group = 'Cargo/crates', icon = '󰏗 ' },
    },
    {
        mode = { 'n', 'x', 'o', 'v' },
        { 'h', group = 'Previews and UI actions', icon = '󰕌 ' },
        { 'hb', group = 'Buffers', icon = ' ' },
        { 'hc', group = 'CodeDiff and conflicts', icon = '󰕚 ' },
        { 'hC', group = 'Bulk conflict actions', icon = '󰕚 ' },
        { 'hd', group = 'Diagnostics', icon = diagnostics.icons.diagnostics },
        { 'hD', group = 'Debug/devtool views', icon = ' ' },
        { 'hG', group = 'Git links and blame', icon = ' ' },
        { 'hg', group = 'Git hunks and buffers', icon = ' ' },
        { 'hl', group = 'LSP previews', icon = '󰔨 ' },
        { 'hlc', group = 'LSP call previews', icon = ' ' },
        { 'hm', group = 'Markdown and notes', icon = '󰍔 ' },
        { 'hmt', group = 'Markdown tables', icon = '󰹹 ' },
        { 'hmta', group = 'Markdown table creation', icon = '󰹹 ' },
        { 'hn', group = 'Node split/join', icon = '󰤻 ' },
        { 'hO', group = 'Tasks', icon = '󰐊 ' },
        { 'hq', group = 'Quickfix windows', icon = '󰁨 ' },
        { 'hr', group = 'Replace workbenches', icon = ' ' },
        { 'hS', group = 'Snippets', icon = ' ' },
        { 'ht', group = 'Pickers', icon = '󰱼 ' },
        { 'hz', group = 'Zoom/Focus/Context', icon = '󰅩 ' },
    },
    {
        mode = { 'n', 'x', 'o' },
        { '[', group = 'Previous item', icon = '󰁍 ' },
        { ']', group = 'Next item', icon = '󰁔 ' },
    },
    {
        mode = { 'n', 'x' },
        { '<C-w>', group = 'Windows', icon = ' ' },
    },
    {
        mode = { 'o', 'x' },
        { 'a', group = 'Around textobject', icon = '󰆧 ' },
        { 'i', group = 'Inside textobject', icon = '󰆧 ' },
    },
    {
        mode = { 'n', 'x' },
        { '<M-s>', group = 'Substitute range', icon = ' ' },
    },
}

return {
    {
        'folke/which-key.nvim',
        lazy = false,
        opts = {
            delay = 250,
            spec = keymap_family_spec,
            win = {
                border = 'rounded',
            },
            triggers = {
                { '<auto>', mode = 'nixsotc' },
                { 'g', mode = 'nxov' },
                { 'h', mode = 'nxov' },
                { '[', mode = 'nxov' },
                { ']', mode = 'nxov' },
                { '<C-w>', mode = 'n' },
                { 'a', mode = 'xo' },
                { 'i', mode = 'xo' },
            },
        },
    },
    {
        -- TODO: configure
        'tris203/hawtkeys.nvim',
        opts = {},
        cmd = {
            'Hawtkeys',
            'HawtkeysAll',
            'HawtkeysDupes',
        },
    },
}
