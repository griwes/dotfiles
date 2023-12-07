local on_attach_callbacks = {}
local capabilities = nil

local M = {
    add_callback = function(callback)
        on_attach_callbacks[#on_attach_callbacks + 1] = callback
    end,

    attach_callbacks = function(language, client, bufnr)
        for _, callback in pairs(on_attach_callbacks)
        do
            callback(language, client, bufnr)
        end
    end,

    get_capabilities = function()
        if capabilities == nil then
            capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }
        end

        return capabilities
    end
}

M.add_callback(function(_, client, bufnr)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(bufnr, true)

        vim.api.nvim_create_augroup('InlayHintsToggles', { clear = true })
        vim.api.nvim_create_autocmd('InsertEnter', {
            group = 'InlayHintsToggles',
            buffer = bufnr,
            callback = function() vim.lsp.inlay_hint.enable(bufnr, false) end
        })
        vim.api.nvim_create_autocmd('InsertLeave', {
            group = 'InlayHintsToggles',
            buffer = bufnr,
            callback = function() vim.lsp.inlay_hint.enable(bufnr, true) end
        })
    end

    require('which-key').register({
        l = {
            h = { vim.lsp.buf.hover, 'Show a hover' },
            i = { function() vim.lsp.inlay_hint(bufnr, nil) end, 'Toggle inlay hints' },
        },
    }, { prefix = '<leader>', buffer = bufnr })
end)

return M
