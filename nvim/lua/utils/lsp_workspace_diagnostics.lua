local M = {}

local method_workspace_diagnostic = vim.lsp.protocol.Methods.workspace_diagnostic or 'workspace/diagnostic'

local function client_supports_workspace_diagnostics(client, bufnr)
    if client.supports_method then
        return client:supports_method(method_workspace_diagnostic, bufnr)
    end

    return false
end

local function populate_client(client, bufnr)
    if client_supports_workspace_diagnostics(client, bufnr) then
        vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
        return
    end

    require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
end

function M.populate(bufnr)
    bufnr = bufnr or 0

    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    if vim.tbl_isempty(clients) then
        clients = vim.lsp.get_clients()
    end

    for _, client in ipairs(clients) do
        populate_client(client, bufnr)
    end
end

return M
