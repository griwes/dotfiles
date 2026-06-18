local util = require('utils.dap_adapters')

local dap = require('dap')

dap.adapters.python = {
    type = 'executable',
    command = util.executable('debugpy-adapter', 'debugpy', 'debugpy-adapter'),
}

util.extend_configurations({ 'python' }, {
    {
        name = 'Python: Launch file',
        type = 'python',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pythonPath = util.python_path,
        console = 'integratedTerminal',
    },
    {
        name = 'Python: Launch file with args',
        type = 'python',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        pythonPath = util.python_path,
        args = util.input_args,
        console = 'integratedTerminal',
    },
    {
        name = 'Python: Launch module',
        type = 'python',
        request = 'launch',
        module = function()
            return vim.fn.input('Python module: ')
        end,
        cwd = '${workspaceFolder}',
        pythonPath = util.python_path,
        args = util.input_args,
        console = 'integratedTerminal',
    },
})
