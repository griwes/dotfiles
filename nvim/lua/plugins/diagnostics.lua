return {
    {
        'griwes/tiny-inline-diagnostic.nvim',
        event = 'LspAttach',
        priority = 1000,
        opts = {
            preset = 'powerline',
            transparent_bg = false,
            blend = {
                factor = 0.19,
            },
            signs = {},
            hi = {
                error = 'DiagnosticError',
                warn = 'DiagnosticWarn',
                info = 'DiagnosticInfo',
                hint = 'DiagnosticHint',
                arrow = 'NonText',
                background = 'PmenuSel',
                mixing_color = 'Normal',
            },
            options = {
                use_icons_from_diagnostic = true,
                set_arrow_to_diag_color = true,
                show_code = true,
                show_source = {
                    enabled = true,
                    if_many = true,
                },
                show_all_diags_on_cursorline = true,
                enable_on_insert = false,
                enable_on_select = false,
                override_open_float = true,
                throttle = 20,
                softwrap = 40,
                right_align = {
                    enabled = true,
                    min_space = 1,
                },
                add_messages = {
                    messages = true,
                    display_count = false,
                    use_max_severity = false,
                    show_multiple_glyphs = true,
                },
                multilines = {
                    enabled = true,
                    always_show = true,
                    trim_whitespaces = true,
                },
                overflow = {
                    mode = 'wrap',
                    padding = 0,
                },
                virt_texts = {
                    priority = 2048,
                },
                highlights = {
                    non_current = {
                        enabled = true,
                        dim_factor = 0.15,
                        dim_color = 'Comment',
                        bg = 'None',
                        italic = true,
                    },
                    current_line = {
                        enabled = true,
                    },
                    under_cursor = {
                        enabled = true,
                        bold = true,
                        underline = false,
                    },
                },
                severity = {
                    vim.diagnostic.severity.ERROR,
                    vim.diagnostic.severity.WARN,
                    vim.diagnostic.severity.INFO,
                    vim.diagnostic.severity.HINT,
                },
            },
        },
    },
}
