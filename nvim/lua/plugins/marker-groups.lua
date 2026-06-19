local marker_icon = '󰃀 '

local marker_group_mappings = {
    marker = {
        add = { suffix = 'a', mode = { 'n', 'x' }, desc = marker_icon .. 'Add marker annotation' },
        edit = { suffix = 'e', desc = marker_icon .. 'Edit marker annotation' },
        delete = { suffix = 'd', desc = marker_icon .. 'Delete marker at cursor' },
        list = { suffix = 'l', desc = marker_icon .. 'List buffer markers' },
        info = { suffix = 'i', desc = marker_icon .. 'Show marker at cursor' },
    },
    group = {
        create = { suffix = 'gc', desc = marker_icon .. 'Create marker group' },
        select = { suffix = 'gs', desc = marker_icon .. 'Select marker group' },
        list = { suffix = 'gl', desc = marker_icon .. 'List marker groups' },
        rename = { suffix = 'gr', desc = marker_icon .. 'Rename marker group' },
        delete = { suffix = 'gd', desc = marker_icon .. 'Delete marker group' },
        info = { suffix = 'gi', desc = marker_icon .. 'Show active marker group' },
        from_branch = { suffix = 'gb', desc = marker_icon .. 'Create marker group from git branch' },
    },
    picker = {
        groups = { suffix = 'tg', desc = marker_icon .. 'Pick marker group' },
        markers = { suffix = 'tm', desc = marker_icon .. 'Pick marker' },
    },
    view = {
        toggle = { suffix = 'v', desc = marker_icon .. 'Toggle marker drawer' },
    },
}

local function key_specs(prefix, mappings)
    local keys = {}

    local function add(entry, default_mode)
        keys[#keys + 1] = {
            prefix .. entry.suffix,
            mode = entry.mode or default_mode or 'n',
            desc = entry.desc,
        }
    end

    for _, section in ipairs({ mappings.marker, mappings.group, mappings.picker, mappings.view }) do
        for _, entry in pairs(section) do
            add(entry)
        end
    end

    return keys
end

return {
    {
        'jameswolensky/marker-groups.nvim',
        dependencies = {
            'folke/snacks.nvim',
            'nvim-lua/plenary.nvim',
        },
        cmd = {
            'MarkerAdd',
            'MarkerEdit',
            'MarkerGroupsCloseDrawer',
            'MarkerGroupsCreate',
            'MarkerGroupsDelete',
            'MarkerGroupsDrawerWidth',
            'MarkerGroupsHealth',
            'MarkerGroupsInfo',
            'MarkerGroupsList',
            'MarkerGroupsPickerStatus',
            'MarkerGroupsRename',
            'MarkerGroupsSelect',
            'MarkerGroupsSetup',
            'MarkerGroupsView',
            'MarkerList',
            'MarkerRemove',
        },
        keys = key_specs('ha', marker_group_mappings),
        opts = {
            picker = 'snacks',
            drawer_config = {
                border = 'rounded',
                side = 'right',
                title_pos = 'center',
                width = 60,
            },
            keymaps = {
                prefix = 'ha',
                mappings = marker_group_mappings,
            },
            signs = {
                marker = '●',
                multiline_start = '┌',
                multiline_end = '└',
            },
        },
    },
}
