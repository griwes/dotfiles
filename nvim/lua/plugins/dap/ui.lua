local icons = {
    debug = ' ',
    continue = ' ',
    pause = ' ',
    step_over = ' ',
    step_into = ' ',
    step_out = ' ',
    step_back = ' ',
    terminate = ' ',
    disconnect = ' ',
    repl = ' ',
    console = ' ',
    scopes = '󰡱 ',
    watches = '󰂥 ',
    stacks = '󰆧 ',
    breakpoints = ' ',
    evaluate = '󰯂 ',
    stopped = ' ',
}

local function trim_icon(icon)
    return icon:gsub('%s+$', '')
end

local function float_element(element)
    return function()
        require('dapui').float_element(element, {
            enter = true,
            width = math.floor(vim.o.columns * 0.8),
            height = math.floor(vim.o.lines * 0.7),
        })
    end
end

return {
    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio',
        },
        event = 'VeryLazy',
        keys = {
            {
                'hDu',
                function()
                    require('dapui').toggle({ reset = true })
                end,
                desc = icons.debug .. 'Toggle debug UI',
            },
            {
                'hDe',
                function()
                    require('dapui').eval(nil, { enter = true })
                end,
                mode = { 'n', 'x' },
                desc = icons.evaluate .. 'Evaluate expression',
            },
            { 'hDs', float_element('scopes'), desc = icons.scopes .. 'Debug scopes float' },
            { 'hDw', float_element('watches'), desc = icons.watches .. 'Debug watches float' },
            { 'hDt', float_element('stacks'), desc = icons.stacks .. 'Debug stack frames float' },
            { 'hDb', float_element('breakpoints'), desc = icons.breakpoints .. 'Debug breakpoints float' },
            { 'hDr', float_element('repl'), desc = icons.repl .. 'Debug REPL float' },
            { 'hDc', float_element('console'), desc = icons.console .. 'Debug console float' },
        },
        opts = {
            controls = {
                enabled = true,
                element = 'repl',
                icons = {
                    disconnect = trim_icon(icons.disconnect),
                    pause = trim_icon(icons.pause),
                    play = trim_icon(icons.continue),
                    run_last = '',
                    step_back = trim_icon(icons.step_back),
                    step_into = trim_icon(icons.step_into),
                    step_out = trim_icon(icons.step_out),
                    step_over = trim_icon(icons.step_over),
                    terminate = trim_icon(icons.terminate),
                },
            },
            expand_lines = true,
            floating = {
                border = 'rounded',
                mappings = {
                    close = { 'q', '<Esc>' },
                },
            },
            force_buffers = true,
            icons = {
                collapsed = '󰅂 ',
                current_frame = icons.stopped,
                expanded = '󰅀 ',
            },
            layouts = {
                {
                    elements = {
                        { id = 'scopes', size = 0.45 },
                        { id = 'watches', size = 0.2 },
                        { id = 'stacks', size = 0.2 },
                        { id = 'breakpoints', size = 0.15 },
                    },
                    position = 'left',
                    size = 56,
                },
                {
                    elements = {
                        { id = 'repl', size = 0.55 },
                        { id = 'console', size = 0.45 },
                    },
                    position = 'bottom',
                    size = 12,
                },
            },
            mappings = {
                edit = 'e',
                expand = { '<CR>', '<2-LeftMouse>' },
                open = 'o',
                remove = 'd',
                repl = 'r',
                toggle = 't',
                watch = 'w',
            },
            render = {
                indent = 1,
                max_value_lines = 120,
            },
        },
        config = function(_, opts)
            local dap = require('dap')
            local dapui = require('dapui')

            dapui.setup(opts)

            dap.listeners.before.attach.dapui_config = function()
                dapui.open({ reset = true })
            end

            dap.listeners.before.launch.dapui_config = function()
                dapui.open({ reset = true })
            end

            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end

            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
    },
}
