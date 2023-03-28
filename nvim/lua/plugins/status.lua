local navic = require('nvim-navic')

require('lualine').setup({
    options = {
        ignore_focus = {
            -- list extension windows that aren't supposed to steal focus here
        },
        globalstatus = true -- TODO: revisit
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', { navic.get_location, cond = navic.is_available } },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        lualine_a = {},
        lualine_b = { 'buffers' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { {
            'tabs',
            mode = 2,
            tabs_color = {
                -- Same values as the general color option can be used here.
                active = 'lualine_b_normal',     -- Color for active tab.
                inactive = 'lualine_b_inactive', -- Color for inactive tab.
            },
        } },
        lualine_z = {}
    },
    winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_winbar = {
        lualine_a = {},
        lualine_b = { 'filename' },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {
        'aerial',
        'nvim-dap-ui',
        'quickfix'
    }
})
