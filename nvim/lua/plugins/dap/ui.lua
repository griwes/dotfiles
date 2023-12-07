return {
    {
        'rcarriga/nvim-dap-ui',
        event = 'VeryLazy',
        config = function()
            local dap = require('dap')
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
        end
    },
}
