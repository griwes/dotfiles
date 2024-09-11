return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        priority = 900,
        opts = {
            ui = {
                border = 'rounded',
            },
        }
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
        },
        lazy = false,
        opts = {
            automatic_installation = true,
            ensure_installed = {
                'ansiblels',
                'bashls',
                'bufls',
                'cmake',
                'jsonls',
                'lua_ls',
                'pyright',
                'texlab',
            },
        }
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        lazy = false,
        opts = {
            ensure_installed = {
                'actionlint',
                'asmfmt',
                'ast-grep',
                'cmakelang',
                'commitlint',
                'gh',
                'gitlint',
                'jq',
                'salt-lint',
                'stylua',
                'woke',
                'yq',
            },
        },
    },
}
