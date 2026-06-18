vim.lsp.config('yamlls', {
    settings = {
        yaml = {
            format = {
                enable = true,
                bracketSpacing = true,
            },
            schemaStore = {
                enable = true,
            },
        },
    },
})
