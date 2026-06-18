local util = require('utils.dap_adapters')

local filetypes = { 'c', 'cpp', 'rust', 'zig' }

local function executable_prompt()
    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local function remote_gdb_target()
    local program = vim.fn.input('Path to local executable/symbols: ', vim.fn.getcwd() .. '/', 'file')
    if program == '' then
        return {}
    end

    return { 'target create ' .. util.lldb_quote(program) }
end

local function remote_gdb_process()
    local endpoint = vim.fn.input('gdb-remote endpoint: ', 'localhost:1234')
    if endpoint == '' then
        endpoint = 'localhost:1234'
    end

    return { 'gdb-remote ' .. endpoint }
end

local dap = require('dap')

dap.adapters.codelldb = {
    type = 'server',
    port = '${port}',
    executable = {
        command = util.executable('codelldb', 'codelldb', 'codelldb'),
        args = { '--port', '${port}' },
    },
}

util.extend_configurations(filetypes, {
    {
        name = 'LLDB: Launch',
        type = 'codelldb',
        request = 'launch',
        program = executable_prompt,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        console = 'integratedTerminal',
    },
    {
        name = 'LLDB: Launch with args',
        type = 'codelldb',
        request = 'launch',
        program = executable_prompt,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = util.input_args,
        console = 'integratedTerminal',
    },
    {
        name = 'LLDB: Attach to process',
        type = 'codelldb',
        request = 'attach',
        pid = '${command:pickProcess}',
        cwd = '${workspaceFolder}',
    },
    {
        name = 'LLDB: Attach to remote gdb server',
        type = 'codelldb',
        request = 'attach',
        targetCreateCommands = remote_gdb_target,
        processCreateCommands = remote_gdb_process,
        stopOnEntry = true,
    },
})
