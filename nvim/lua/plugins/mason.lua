return {
    {
        'mason-org/mason.nvim',
        lazy = false,
        priority = 900,
        opts = {
            ui = {
                backdrop = 100,
                border = 'rounded',
            },
        },
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            'mason-org/mason.nvim',
        },
        lazy = false,
        opts = {
            automatic_enable = {
                exclude = { 'copilot' },
            },
            ensure_installed = {
                'ansiblels',
                'asm_lsp',
                'basedpyright',
                'bashls',
                'buf_ls',
                'clangd',
                'copilot',
                'cssls',
                'eslint',
                'gh_actions_ls',
                'graphql',
                'harper_ls',
                'jsonls',
                'lua_ls',
                'neocmake',
                'ruff',
                'rust_analyzer',
                'stylelint_lsp',
                'systemd_lsp',
                'texlab',
                'vtsls',
                'yamlls',
            },
        },
    },
    {
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        lazy = false,
        opts = {
            -- Mason owns editor-invoked LSP, DAP, lint, format, and helper binaries.
            -- General shell tools that are useful outside Neovim belong in mise.
            ensure_installed = {
                'actionlint',
                'ansible-lint',
                'asmfmt',
                'ast-grep',
                'bash-debug-adapter',
                -- cmakelang installs both cmake-format and cmake-lint.
                'cmakelang',
                'codelldb',
                'commitlint',
                'debugpy',
                'gersemi',
                'gitlint',
                'js-debug-adapter',
                'local-lua-debugger-vscode',
                'salt-lint',
                'systemdlint',
                'tree-sitter-cli',
                'woke',
            },
        },
    },
}
