require('notify').setup({
    background_colour = '#000000'
})
vim.notify = require('notify')

require('noice').setup({
    cmdline = {
        view = 'cmdline'
    },
    messages = {
        view_history = 'popup'
    },
    popupmenu = {
        backend = 'cmp'
    },

    lsp = {
        override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
        },
    },

    presets = {
        lsp_doc_border = true,
    },

    views = {
        popup = {
            border = {
                style = 'rounded'
            }
        }
    }
})

vim.g.code_action_menu_window_border = 'rounded'
vim.g.code_action_menu_show_diff = true

require('dressing').setup({
})

-- vim.cmd [[ highlight StatusLine guifg=#505050 ]]
-- vim.cmd [[ highlight StatusLineNC guifg=#505050 ]]
vim.cmd [[ highlight VertSplit guifg=#505050 ]]

vim.cmd [[ highlight NormalFloat guibg=None ]] -- TODO: move elsewhere?

-- require('neo-zoom').setup({
--    winopts = {
--        offset = {
--            width = 0.85,
--            height = 0.9
--        },
--        border = 'rounded'
--    },
--    callbacks = {
--        function ()
--            vim.cmd([[
--                hi NeoZoomFloatBg guibg=None
--                set winhl=Normal:NeoZoomFloatBg
--            ]])
--        end,
--    },
--})

require('smart-splits').setup({
    tmux_integration = false,
})

require('bufresize').setup({
})

require('which-key').setup({
})

require('trouble').setup({
    position = 'bottom',
    auto_open = true,
    auto_close = true,
})

require('fidget').setup({
})

require('aerial').setup({
    backends = { 'lsp', 'treesitter', 'markdown', 'man' },
    layout = {
        min_width = 20,
    },
    filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Module',
        'Method',
        'Struct',
        'Namespace',
    },
})
require('telescope').load_extension('aerial')

require('scope').setup({
})

