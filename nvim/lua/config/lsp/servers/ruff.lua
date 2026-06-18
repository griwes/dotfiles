vim.lsp.config('ruff', {
    on_attach = function(client)
        -- basedpyright owns Python navigation, types, and hover. Ruff stays focused
        -- on lint diagnostics and quick fixes.
        client.server_capabilities.hoverProvider = false
    end,
})
