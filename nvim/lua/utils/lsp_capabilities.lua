local M = {}
local capabilities = nil

local function make_file_operation_capabilities()
    return {
        workspace = {
            fileOperations = {
                dynamicRegistration = false,
                willCreate = true,
                didCreate = true,
                willRename = true,
                didRename = true,
                willDelete = true,
                didDelete = true,
            },
        },
    }
end

function M.get()
    if capabilities == nil then
        capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        capabilities = vim.tbl_deep_extend('force', capabilities, make_file_operation_capabilities())
    end

    return capabilities
end

return M
