return {
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        event = 'VeryLazy',
        opts = {
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
        }
    }
}

