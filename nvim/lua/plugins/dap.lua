local dap = require('dap')

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode',
    name = 'lldb'
}

dap.configurations.lldb = {
    {
        name = 'Launch a process',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
    },
    {
        name = 'Attach to a process',
        type = 'lldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        args = {},
    },
}

local dapui = require('dapui')

dapui.setup({
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
        }, {
            id = "breakpoints",
            size = 0.25
        }, {
            id = "stacks",
            size = 0.25
        }, {
            id = "watches",
            size = 0.25
        } },
        position = "left",
        size = 80
      }, {
        elements = { {
            id = "repl",
            size = 1
        } },
        position = "bottom",
        size = 15
    } },
})

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end

dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

require('nvim-dap-virtual-text').setup({
})
