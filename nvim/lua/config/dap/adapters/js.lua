local util = require('utils.dap_adapters')

local adapter_names = {
    'pwa-node',
    'pwa-chrome',
}

local node_filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
}

local web_filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'html',
    'css',
    'scss',
    'less',
}

local function node_inspector_port()
    return util.input_port('Node inspector port: ', '9229')
end

local function chrome_debug_port()
    return util.input_port('Chrome debug port: ', '9222')
end

local dap = require('dap')
local adapter = {
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = {
        command = util.executable('js-debug-adapter', 'js-debug-adapter', 'js-debug-adapter'),
        args = { '${port}' },
    },
}

for _, name in ipairs(adapter_names) do
    dap.adapters[name] = adapter
end

util.extend_configurations(node_filetypes, {
    {
        name = 'Node: Launch file',
        type = 'pwa-node',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'node',
        skipFiles = { '<node_internals>/**' },
        console = 'integratedTerminal',
    },
    {
        name = 'Node: Launch file with args',
        type = 'pwa-node',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        runtimeExecutable = 'node',
        args = util.input_args,
        skipFiles = { '<node_internals>/**' },
        console = 'integratedTerminal',
    },
    {
        name = 'Node: Attach inspector',
        type = 'pwa-node',
        request = 'attach',
        address = '127.0.0.1',
        port = node_inspector_port,
        cwd = '${workspaceFolder}',
        skipFiles = { '<node_internals>/**' },
    },
})

util.extend_configurations(web_filetypes, {
    {
        name = 'Chrome: Attach localhost',
        type = 'pwa-chrome',
        request = 'attach',
        url = function()
            return vim.fn.input('Chrome URL: ', 'http://localhost:3000')
        end,
        port = chrome_debug_port,
        webRoot = '${workspaceFolder}',
    },
})
