local diagnostics = require('utils.diagnostics')

if vim.g.dotfiles_diagnostic_virtual_lines == nil then
    -- Keep the native current-line virtual_lines path preserved but inactive.
    -- Set this to true, or call toggle_native_virtual_lines(), to reverse course
    -- from tiny-inline-diagnostic.nvim back to non-plugin native rendering.
    vim.g.dotfiles_diagnostic_virtual_lines = false
end

vim.diagnostic.config({
    signs = {
        text = diagnostics.sign_text,
    },
    virtual_text = false,
    virtual_lines = diagnostics.virtual_lines(),
    severity_sort = true,
    update_in_insert = false,
})

vim.api.nvim_create_augroup('DiagnosticVirtualLinesToggles', { clear = false })
vim.api.nvim_create_autocmd('InsertEnter', {
    group = 'DiagnosticVirtualLinesToggles',
    pattern = '*',
    callback = function()
        for _, client in pairs(vim.lsp.get_clients()) do
            local client_ns = vim.lsp.diagnostic.get_namespace(client.id, false)
            vim.diagnostic.config({
                virtual_lines = false,
            }, client_ns)
        end
    end,
})

vim.api.nvim_create_autocmd('InsertLeave', {
    group = 'DiagnosticVirtualLinesToggles',
    pattern = '*',
    callback = function()
        diagnostics.apply_virtual_lines()
    end,
})
