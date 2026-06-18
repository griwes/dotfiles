local function toggle(bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

local function attach(client, bufnr)
    if not client.server_capabilities.inlayHintProvider then
        return
    end

    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    if vim.b[bufnr].lsp_inlay_hints_autocmds then
        return
    end
    vim.b[bufnr].lsp_inlay_hints_autocmds = true

    vim.api.nvim_create_autocmd('InsertEnter', {
        group = 'LspInlayHintsToggles',
        buffer = bufnr,
        callback = function()
            vim.b[bufnr].inlay_hints_state = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end,
    })

    vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave' }, {
        group = 'LspInlayHintsToggles',
        buffer = bufnr,
        callback = function()
            local enabled = vim.b[bufnr].inlay_hints_state
            if enabled == nil then
                enabled = true
            end
            vim.lsp.inlay_hint.enable(enabled, { bufnr = bufnr })
        end,
    })
end

vim.api.nvim_create_augroup('LspInlayHintsToggles', { clear = true })
vim.api.nvim_create_augroup('LspInlayHints', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspInlayHints',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        attach(client, args.buf)
    end,
})
