return {
    {
        'folke/lazydev.nvim',
        lazy = false,
        opts = {
        },
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'SmiteshP/nvim-navbuddy',
            'folke/neodev.nvim',
        },
        config = function()
            local lspc = require('lspconfig')
            local utils = require('utils.lsp')

            local options = {
                on_attach = utils.attach_callbacks,
                capabilities = utils.get_capabilities(),
            }

            require('mason-lspconfig').setup_handlers({
                function(server_name)
                    lspc[server_name].setup(options)
                end,

                clangd = function() end,
                rust_analyzer = function()
                    lspc.rust_analyzer.setup({
                        on_attach = utils.attach_callbacks,
                        capabilities = utils.get_capabilities(),
                        settings = {
                            ['rust-analyzer'] = {
                                checkOnSave = true,
                                diagnostics = {
                                    enable = false,
                                    experimental = {
                                        enable = false,
                                    },
                                },
                            },
                        },
                    })
                end,
            })
            local sign_text = {
                [vim.diagnostic.severity.ERROR] = ' ',
                [vim.diagnostic.severity.WARN] = '󰀪 ',
                [vim.diagnostic.severity.INFO] = ' ',
                [vim.diagnostic.severity.HINT] = ' ',
            }

            vim.diagnostic.config({
                signs = {
                    text = sign_text
                },
                severity_sort = true,
                update_in_insert = true,
            })
        end
    },
    {
        'yorickpeterse/nvim-dd',
        lazy = false,
        opts = {
            timeout = 250,
        },
    },
}
