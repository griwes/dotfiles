local icons = {
    debug = ' ',
    breakpoint = ' ',
    conditional_breakpoint = ' ',
    logpoint = ' ',
    rejected_breakpoint = ' ',
    stopped = ' ',
    continue = ' ',
    pause = ' ',
    step_over = ' ',
    step_into = ' ',
    step_out = ' ',
    step_back = ' ',
    terminate = ' ',
    disconnect = ' ',
    repl = ' ',
    breakpoints = ' ',
    exception = ' ',
    save = '󰆓 ',
    load = '󰋚 ',
}

local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO, { title = 'DAP' })
end

local function dap_action(action)
    return function()
        require('dap')[action]()
    end
end

local function breakpoint_action(action)
    return function()
        require('dap-breakpoints.api')[action]()
    end
end

local function edit_all_breakpoint_properties()
    require('dap-breakpoints.api').edit_property({ all = true })
end

local function load_breakpoints()
    require('dap-breakpoints.api').load_breakpoints({ notify = 'always' })
end

local function save_breakpoints()
    require('dap-breakpoints.api').save_breakpoints({ notify = 'always' })
end

local function list_breakpoints()
    require('dap').list_breakpoints(true)
end

local function launch_osv_server()
    local ok, osv = pcall(require, 'osv')
    if not ok then
        notify('one-small-step-for-vimkind is not available', vim.log.levels.ERROR)
        return
    end

    vim.ui.input({ prompt = 'OSV port: ', default = '8086' }, function(port)
        if not port or port == '' then
            return
        end

        osv.launch({ port = tonumber(port) or 8086 })
    end)
end

local function setup_signs()
    vim.fn.sign_define('DapBreakpoint', {
        text = icons.breakpoint,
        texthl = 'DiagnosticSignError',
        numhl = 'DiagnosticSignError',
    })
    vim.fn.sign_define('DapBreakpointCondition', {
        text = icons.conditional_breakpoint,
        texthl = 'DiagnosticSignWarn',
        numhl = 'DiagnosticSignWarn',
    })
    vim.fn.sign_define('DapBreakpointRejected', {
        text = icons.rejected_breakpoint,
        texthl = 'DiagnosticSignError',
        numhl = 'DiagnosticSignError',
    })
    vim.fn.sign_define('DapLogPoint', {
        text = icons.logpoint,
        texthl = 'DiagnosticSignInfo',
        numhl = 'DiagnosticSignInfo',
    })
    vim.fn.sign_define('DapStopped', {
        text = icons.stopped,
        texthl = 'DiagnosticSignInfo',
        numhl = 'DiagnosticSignInfo',
    })
end

return {
    {
        'mfussenegger/nvim-dap',
        event = 'VeryLazy',
        dependencies = {
            'jbyuki/one-small-step-for-vimkind',
        },
        keys = {
            { 'gdc', dap_action('continue'), desc = icons.continue .. 'Debug continue/start' },
            { 'gdC', dap_action('run_last'), desc = icons.continue .. 'Debug run last' },
            { 'gdp', dap_action('pause'), desc = icons.pause .. 'Debug pause' },
            { 'gdt', dap_action('terminate'), desc = icons.terminate .. 'Debug terminate' },
            { 'gdT', dap_action('disconnect'), desc = icons.disconnect .. 'Debug disconnect' },
            { 'gdo', dap_action('step_over'), desc = icons.step_over .. 'Debug step over' },
            { 'gdi', dap_action('step_into'), desc = icons.step_into .. 'Debug step into' },
            { 'gdO', dap_action('step_out'), desc = icons.step_out .. 'Debug step out' },
            { 'gdB', dap_action('step_back'), desc = icons.step_back .. 'Debug step back' },
            { 'gdg', dap_action('run_to_cursor'), desc = icons.debug .. 'Debug run to cursor' },
            {
                'gdr',
                function()
                    require('dap').repl.toggle()
                end,
                desc = icons.repl .. 'Debug toggle REPL',
            },
            { 'gdL', launch_osv_server, desc = icons.debug .. 'Debug launch Neovim Lua server' },
        },
        config = function()
            setup_signs()
            require('config.dap.adapters')
        end,
    },
    {
        'Weissle/persistent-breakpoints.nvim',
        lazy = true,
        dependencies = {
            'mfussenegger/nvim-dap',
        },
        opts = {
            save_dir = vim.fn.stdpath('data') .. '/dap-breakpoints',
            load_breakpoints_event = nil,
            always_reload = false,
        },
        config = function(_, opts)
            require('persistent-breakpoints').setup(opts)
        end,
    },
    {
        'Carcuis/dap-breakpoints.nvim',
        dependencies = {
            'mfussenegger/nvim-dap',
            'Weissle/persistent-breakpoints.nvim',
        },
        event = { 'BufReadPre', 'BufNewFile' },
        keys = {
            { 'gdb', breakpoint_action('toggle_breakpoint'), desc = icons.breakpoint .. 'Debug toggle breakpoint' },
            { 'gds', breakpoint_action('set_breakpoint'), desc = icons.breakpoint .. 'Debug set breakpoint' },
            {
                'gde',
                breakpoint_action('set_conditional_breakpoint'),
                desc = icons.conditional_breakpoint .. 'Debug conditional breakpoint',
            },
            {
                'gdh',
                breakpoint_action('set_hit_condition_breakpoint'),
                desc = icons.conditional_breakpoint .. 'Debug hit-condition breakpoint',
            },
            { 'gdl', breakpoint_action('set_log_point'), desc = icons.logpoint .. 'Debug logpoint' },
            { 'gd?', list_breakpoints, desc = icons.breakpoints .. 'Debug list breakpoints' },
            { 'gdP', breakpoint_action('popup_reveal'), desc = icons.breakpoints .. 'Debug reveal breakpoint' },
            { 'gdE', breakpoint_action('edit_property'), desc = icons.breakpoints .. 'Debug edit breakpoint' },
            { 'gdA', edit_all_breakpoint_properties, desc = icons.breakpoints .. 'Debug edit all breakpoint fields' },
            { 'gdX', breakpoint_action('edit_exception_filters'), desc = icons.exception .. 'Debug exception filters' },
            {
                'gdv',
                breakpoint_action('toggle_virtual_text'),
                desc = icons.breakpoints .. 'Debug breakpoint virtual text',
            },
            { 'gdw', save_breakpoints, desc = icons.save .. 'Debug save breakpoints' },
            { 'gdW', load_breakpoints, desc = icons.load .. 'Debug load breakpoints' },
            { ']B', breakpoint_action('go_to_next'), desc = icons.breakpoints .. 'Next breakpoint' },
            { '[B', breakpoint_action('go_to_previous'), desc = icons.breakpoints .. 'Previous breakpoint' },
        },
        opts = {
            auto_load = true,
            auto_save = true,
            auto_reveal_popup = true,
            virtual_text = {
                enabled = true,
                priority = 20,
                current_line_only = false,
                preset = 'default',
                order = 'chl',
                layout = {
                    position = 'right_align',
                    spaces = 4,
                },
                prefix = {
                    normal = icons.breakpoint,
                    log_point = icons.logpoint,
                    conditional = icons.conditional_breakpoint,
                    hit_condition = '󰰁 ',
                },
                custom_text_handler = nil,
            },
        },
        config = function(_, opts)
            require('dap-breakpoints').setup(opts)
        end,
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        event = 'VeryLazy',
        dependencies = {
            'mfussenegger/nvim-dap',
        },
        opts = {},
    },
}
