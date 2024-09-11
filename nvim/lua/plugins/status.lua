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
                    component_separators = { left = ' ', right = ' ' },
                    section_separators = { left = ' ', right = ' ' },
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
        'b0o/incline.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',
        },
        event = 'VeryLazy',
        opts = {
            window = {
                margin = {
                    vertical = 0,
                    horizontal = 0,
                },
                options = {
                    winblend = 0,
                },
                overlap = {
                    borders = false,
                },
                placement = {
                    vertical = 'top',
                },
                zindex = 25,
            },
            render = function(props)
                local function get_diagnostic_label()
                    local severities = { 'ERROR', 'WARN', 'INFO', 'HINT' }
                    local label = {}
                    local sign_text = vim.diagnostic.config().signs.text

                    for _, severity_name in ipairs(severities) do
                        local severity = vim.diagnostic.severity[severity_name]
                        ---@diagnostic disable-next-line: need-check-nil
                        local icon = sign_text[severity]
                        local n = vim.diagnostic.count(props.buf, { severity = severity })[severity] or 0
                        if n > 0 then
                            table.insert(label, { icon .. n .. ' ', group = 'DiagnosticSign' .. severity_name })
                        end
                    end
                    if #label > 0 then
                        table.insert(label, { '| ' })
                    end
                    return label
                end
                local function get_git_diff()
                    local icons = { { 'added', ' ' }, { 'changed', ' ' }, { 'removed', ' ' } }
                    local labels = {}
                    local signs = vim.b[props.buf].gitsigns_status_dict
                    if signs == nil then
                        return {}
                    end
                    for _, data in ipairs(icons) do
                        local name = data[1]
                        local icon = data[2]
                        if tonumber(signs[name]) and signs[name] > 0 then
                            table.insert(labels, { icon .. signs[name] .. ' ', group = 'Diff' .. name })
                        end
                    end
                    if #labels > 0 then
                        table.insert(labels, { '| ' })
                    end
                    return labels
                end

                local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
                local ft = vim.bo[props.buf].filetype
                local ft_icon, ft_color = require('nvim-web-devicons').get_icon_color_by_filetype(ft)

                local buffer = {
                    { get_diagnostic_label() },
                    { get_git_diff() },
                    { ft_icon,                                   guifg = ft_color },
                    { ' ' },
                    { filename,                                  gui = vim.bo[props.buf].modified and 'italic' or '' },
                    { vim.bo[props.buf].modified and '[+]' or '' },
                    { vim.bo[props.buf].readonly and '[-]' or '' },
                }
                return buffer
            end
        }
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
                        text = { ' ' },
                    },
                    {
                        sign = {
                            namespace = { 'vim.lsp.*/diagnostic/signs' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = true,
                        },
                        click = 'v:lua.ScSa'
                    },
                    {
                        sign = {
                            name = { 'todo.sign..*' },
                            maxwidth = 1,
                            colwidth = 2,
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
                            namespace = { 'trailblazer' },
                            maxwidth = 1,
                            colwidth = 2,
                            auto = true,
                        },
                    },
                    {
                        sign = {
                            name = { 'Dap*' },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true
                        },
                        click = 'v:lua.ScSa'
                    },
                    {
                        sign = {
                            name = { 'octo_*' },
                            maxwidth = 2,
                            colwidth = 1,
                            auto = true
                        },
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
        'utilyre/barbecue.nvim',
        opts = {
            show_modified = true,
        }
    },
    --[[
    {
        'EtiamNullam/fold-ribbon.nvim',
        config = function()
            require('fold-ribbon').setup()
        end,
    },
    ]]--
}
