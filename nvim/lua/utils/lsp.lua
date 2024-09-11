local on_attach_callbacks = {}
local capabilities = nil

local M = {
    add_callback = function(callback)
        on_attach_callbacks[#on_attach_callbacks + 1] = callback
    end,

    attach_callbacks = function(client, bufnr)
        for _, callback in pairs(on_attach_callbacks)
        do
            callback(client, bufnr)
        end
    end,

    get_capabilities = function()
        if capabilities == nil then
            capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            capabilities.textDocument.completion.completionItem.snippetSupport = true
        end

        return capabilities
    end
}

M.add_callback(function(client, bufnr)
    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
        vim.api.nvim_create_augroup('InlayHintsToggles', { clear = false })
        vim.api.nvim_create_autocmd('InsertEnter', {
            group = 'InlayHintsToggles',
            buffer = bufnr,
            callback = function() vim.lsp.inlay_hint.enable(false, { bufnr = 0 }) end
        })
        vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave' }, {
            group = 'InlayHintsToggles',
            buffer = bufnr,
            callback = function() vim.lsp.inlay_hint.enable(true, { bufnr = 0 }) end
        })
    end

    local on_list = function(opts)
        vim.fn.setloclist(0, {}, ' ', opts)
        vim.cmd.lopen()
    end

    require('which-key').add({ {
        '<leader>li',
        function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(),
                { bufnr = 0 })
        end,
        desc = 'Toggle inlay hints',
        buffer = bufnr
    }, {
        'gpr',
        function() vim.lsp.buf.references(nil, { loclist = true }) end,
        desc = 'Preview LSP references',
        buffer = bufnr
    }, {
        'gpd',
        function() vim.lsp.buf.definition({ loclist = true, on_list = on_list }) end,
        desc = 'Preview LSP definitions',
        buffer = bufnr
    }, {
        'gpt',
        function() vim.lsp.buf.type_definition({ loclist = true, on_list = on_list }) end,
        desc = 'Preview LSP type definitions',
        buffer = bufnr
    }, {
        'gpi',
        function() vim.lsp.buf.implementation({ loclist = true, on_list = on_list }) end,
        desc = 'Preview LSP implementations',
        buffer = bufnr
    }, {
        'gpci',
        function() vim.lsp.buf.incoming_calls() end,
        desc = 'Preview LSP incoming calls',
        buffer = bufnr
    }, {
        'gpco',
        function() vim.lsp.buf.outgoing_calls() end,
        desc = 'Preview LSP outgoing calls',
        buffer = bufnr
    }, {
        '<leader>ls',
        function() vim.diagnostic.open_float() end,
        desc = "Open diagnostics float",
        buffer = bufnr
    } })
end)
return M
