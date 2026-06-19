local log_icon = ' '
local candela_icon = '󰗢 '

local function set_log_filetype()
    vim.bo.filetype = 'log'
end

local function with_candela(callback)
    return function()
        local candela = require('candela')
        if candela.ensure_init() then
            callback()
        end
    end
end

local function add_candela_pattern()
    vim.ui.input({ prompt = candela_icon .. 'Candela regex: ' }, function(regex)
        if not regex or regex == '' then
            return
        end

        local added = require('candela.patterns').add(regex)
        if not added then
            return
        end

        local highlighter = require('candela.highlighter')
        highlighter.highlight(added)
        highlighter.refresh_ui()
    end)
end

local function send_candela_patterns_to_loclist()
    local patterns = require('candela.patterns')
    local regexes = vim.tbl_keys(patterns.patterns)

    if vim.tbl_isempty(regexes) then
        vim.notify('No Candela patterns to send to the location list', vim.log.levels.INFO, { title = 'Candela' })
        return
    end

    table.sort(regexes)
    if require('candela.locator').loclist(regexes) then
        vim.cmd.lopen()
    end
end

return {
    {
        'fei6409/log-highlight.nvim',
        lazy = false,
        keys = {
            {
                'hTll',
                set_log_filetype,
                desc = log_icon .. 'Treat buffer as log',
            },
        },
        opts = {
            extension = { 'log', 'logs' },
            filename = {
                'dmesg',
                'messages',
                'syslog',
            },
            pattern = {
                '%/var%/log%/.*',
                'console%-ramoops.*',
                'log.*%.txt',
                'logcat.*',
            },
        },
    },
    {
        'kicanter/candela.nvim',
        cmd = 'Candela',
        keys = {
            {
                'hTcc',
                with_candela(function()
                    require('candela.ui').toggle()
                end),
                desc = candela_icon .. 'Toggle Candela',
            },
            {
                'hTca',
                with_candela(add_candela_pattern),
                desc = candela_icon .. 'Add Candela regex',
            },
            {
                'hTcl',
                with_candela(function()
                    local view = require('candela.config').options.lightbox.default_view
                    require('candela.lightbox').toggle(view)
                end),
                desc = candela_icon .. 'Toggle Candela lightbox',
            },
            {
                'hTcr',
                with_candela(function()
                    local highlighter = require('candela.highlighter')
                    highlighter.refresh()
                    highlighter.refresh_ui()
                end),
                desc = candela_icon .. 'Refresh Candela matches',
            },
            {
                'hTcq',
                with_candela(send_candela_patterns_to_loclist),
                desc = candela_icon .. 'Candela matches to loclist',
            },
            {
                'hTcx',
                with_candela(function()
                    require('candela.highlighter').remove_all()
                    require('candela.patterns').clear()
                    require('candela.highlighter').refresh_ui()
                end),
                desc = candela_icon .. 'Clear Candela patterns',
            },
            {
                'hTch',
                with_candela(function()
                    require('candela.ui').help()
                end),
                desc = candela_icon .. 'Show Candela help',
            },
        },
        ---@type Candela.Config
        opts = {
            icons = {
                nerd_font = true,
            },
            lightbox = {
                fold_style = 'detailed',
            },
            syntax_highlighting = {
                enabled = false,
            },
        },
    },
}
