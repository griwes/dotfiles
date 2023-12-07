return {
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
        },
        opts = {
            ensure_installed = {
                'ansiblels',
                'clangd',
                'rust_analyzer',
                'cmake',
                'bashls',
                'texlab',
                'lua_ls',
                'pyright',
            }
        }
    },
    {
        "folke/neodev.nvim",
        lazy = false,
        opts = {
            override = function(root_dir, library)
                if root_dir:find(os.getenv('HOME') .. '/dotfiles/nvim', 1, true) == 1 then
                    library.enabled = true
                    library.runtime = true
                    library.types = true
                    library.plugins = true
                end
            end
        },
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim',
            'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        },
        config = function()
            local lspc = require('lspconfig')
            local utils = require('utils.lsp')

            local function options(lang)
                return {
                    on_attach = function(client, bufnr)
                        utils.attach_callbacks('ansible', client, bufnr)
                    end,
                    capabilities = utils.get_capabilities()
                }
            end

            lspc.ansiblels.setup(options('ansible'))
            lspc.cmake.setup(options('cmake'))
            lspc.bashls.setup(options('bash'))
            lspc.texlab.setup(options('latex'))
            lspc.lua_ls.setup(options('lua'))
            lspc.pyright.setup(options('python'))
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
