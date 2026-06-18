local util = require('utils.dap_adapters')

local function local_lua_package_path()
    return util.mason_package_path('local-lua-debugger-vscode')
        or vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages', 'local-lua-debugger-vscode')
end

local function local_lua_extension_path()
    return vim.fs.joinpath(local_lua_package_path(), 'extension')
end

local function local_lua_debug_adapter_path()
    return vim.fs.joinpath(local_lua_extension_path(), 'extension', 'debugAdapter.js')
end

local dap = require('dap')

dap.adapters['local-lua'] = {
    type = 'executable',
    command = util.executable('node'),
    args = { local_lua_debug_adapter_path() },
    enrich_config = function(config, on_config)
        if config.extensionPath then
            on_config(config)
            return
        end

        local enriched = vim.deepcopy(config)
        enriched.extensionPath = local_lua_extension_path()
        on_config(enriched)
    end,
}

dap.adapters.nlua = function(callback, config)
    callback({
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or 8086,
    })
end

util.extend_configurations({ 'lua' }, {
    {
        name = 'Lua: Launch file',
        type = 'local-lua',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = {
            lua = util.lua_path,
            file = '${file}',
        },
        args = {},
    },
    {
        name = 'Lua: Launch file with args',
        type = 'local-lua',
        request = 'launch',
        cwd = '${workspaceFolder}',
        program = {
            lua = util.lua_path,
            file = '${file}',
        },
        args = util.input_args,
    },
    {
        name = 'Neovim Lua: Attach to running OSV server',
        type = 'nlua',
        request = 'attach',
        host = function()
            return vim.fn.input('OSV host: ', '127.0.0.1')
        end,
        port = function()
            return util.input_port('OSV port: ', '8086')
        end,
    },
})
