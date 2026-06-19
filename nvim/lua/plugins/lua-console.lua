local function toggle_console()
    require('lua-console').toggle_console()
end

local function attach_console()
    vim.api.nvim_cmd({ cmd = 'LuaConsole', args = { 'AttachToggle' } }, {})
end

return {
    {
        'YaroSpace/lua-console.nvim',
        cmd = 'LuaConsole',
        keys = {
            { 'hLt', toggle_console, desc = ' Toggle Lua console' },
            { 'hLa', attach_console, desc = ' Attach Lua evaluator' },
        },
        opts = {
            window = {
                border = 'rounded',
                title = ' Lua console ',
                title_pos = 'left',
                height = 0.5,
            },
            mappings = {
                -- Keep global mappings in this file through lazy.nvim keys,
                -- rather than accepting lua-console.nvim's defaults.
                toggle = false,
                attach = false,
                kill_ps = false,

                -- Console/evaluator-local maps.
                quit = 'q',
                eval = '<CR>',
                eval_buffer = '<S-CR>',
                open = 'gf',
                messages = 'M',
                save = 'S',
                load = 'L',
                resize_up = '<C-Up>',
                resize_down = '<C-Down>',
                help = '?',
            },
        },
    },
}
