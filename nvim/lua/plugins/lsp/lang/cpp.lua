return {
    {
        'p00f/clangd_extensions.nvim',
        lazy = false,
        config = function()
            local utils = require('utils.lsp')
            require('lspconfig').clangd.setup({
                cmd = {
                    'clangd',
                    [[--all-scopes-completion]],
                    [[--background-index]],
                    [[--clang-tidy]],
                    [[--completion-style=detailed]],
                    [[--header-insertion=never]]
                },
                on_attach = function(client, bufnr)
                    utils.attach_callbacks(client, bufnr)
                end,
                capabilities = utils.get_capabilities(),
            })
            require('clangd_extensions').setup({
                extensions = {
                    autoSetHints = false,
                    inlay_hints = {
                        inline = false,
                    },
                },
            })
        end
    }
}
