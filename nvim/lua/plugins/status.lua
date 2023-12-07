return {
    {
        'nvim-lualine/lualine.nvim',
        event = 'VeryLazy',
        dependencies = {
            'lewis6991/gitsigns.nvim',
        },
        config = function()
            require('lualine').setup({
                options = {
                    ignore_focus = {
                        -- list extension windows that aren't supposed to steal focus here
                    },
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = { 'diagnostics', 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = { 'diff' },
                    lualine_c = { { 'filename', path = 1 } },
                    lualine_x = { 'diagnostics' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {
                    'quickfix',
                    'nvim-dap-ui'
                }
            })

            local llhls = require('lualine.highlight')
            llhls.get_lualine_hl('lualine_a_insert')
            llhls.get_lualine_hl('lualine_a_terminal')
            llhls.get_lualine_hl('lualine_a_normal')
            llhls.get_transitional_highlights('lualine_a_insert', 'lualine_c_insert')
            llhls.get_transitional_highlights('lualine_a_terminal', 'lualine_c_terminal')
            llhls.get_transitional_highlights('lualine_a_normal', 'lualine_c_normal')
        end,
    },
    {
        -- TODO: hide some sections when not in the current window
        'luukvbaal/statuscol.nvim',
        branch = '0.10',
        config = function()
            local builtin = require('statuscol.builtin')
            require('statuscol').setup({
                thousands = nil,
                relculright = true,
                segments = {
                    {
                        text = { builtin.foldfunc },
                        click = 'v:lua.ScFa'
                    },
                    {
                        sign = {
                            name = { 'Diagnostic' },
                            maxwidth = 3,
                            colwidth = 1,
                            auto = true,
                        },
                        click = 'v:lua.ScSa'
                    },
                    {
                        sign = {
                            name = { 'Marks.*' },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true,
                        },
                        click = 'v:lua.ScSa'
                    },
                    {
                        sign = {
                            name = { "Dap*" },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true
                        },
                        click = "v:lua.ScSa"
                    },
                    {
                        text = { builtin.lnumfunc },
                        click = 'v:lua.ScLa',
                    },
                    {
                        sign = {
                            namespace = { 'gitsigns' },
                            maxwidth = 1,
                            wrap = true
                        },
                        click = 'v:lua.ScSa'
                    },
                },
                clickhandlers = {
                    FoldOther = function(args)
                        if args.button == 'l' then
                            vim.cmd('silent! norm! z' .. (args.mods:find('m') and 'A' or 'a'))
                        else
                            builtin.foldother_click(args)
                        end
                    end,
                }
            })
        end,
    },
    {
        'lewis6991/satellite.nvim',
        --branch = 'incre',
        event = 'VeryLazy',
        opts = {
            winblend = 25,
            zindex = 1,
            search = {
                enable = true,
            },
        },
    },
    --{
        --'nanozuki/tabby.nvim',
        --event = 'VeryLazy',
        --opts = {
        --},
    --},
    --{
        --'tiagovla/scope.nvim',
        --lazy = false,
        --opts = {
        --},
    --},
    {
        'Bekaboo/dropbar.nvim',
        opts = {
            menu = {
                win_configs = {
                    border = 'rounded',
                },
            },
            icons = {
                ui = {
                    bar = {
                        separator = '  ',
                    },
                    menu = {
                        indicator = '',
                    },
                },
            },
        },
    },
}

