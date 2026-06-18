vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            checkOnSave = true,
            diagnostics = {
                enable = true,
                experimental = {
                    enable = true,
                },
            },
        },
    },
})
