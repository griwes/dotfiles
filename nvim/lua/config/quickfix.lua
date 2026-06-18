local icons = {
    quickfix = '󰁨 ',
    loclist = '󰍉 ',
}

local function command(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local function open_quickfix()
    vim.cmd.copen()
end

local function close_quickfix()
    vim.cmd.cclose()
end

local function open_loclist()
    vim.cmd.lopen()
end

local function close_loclist()
    vim.cmd.lclose()
end

local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
end

local function setup_global_maps()
    map('hqo', open_quickfix, icons.quickfix .. 'Open quickfix with preview')
    map('hqc', close_quickfix, icons.quickfix .. 'Close quickfix')
    map('hlo', open_loclist, icons.loclist .. 'Open loclist with preview')
    map('hlC', close_loclist, icons.loclist .. 'Close loclist')
end

local function setup_bracket_nav(bracket_nav)
    bracket_nav.map('q', {
        icon = icons.quickfix,
        desc = 'quickfix item',
        next = command('cnext'),
        prev = command('cprevious'),
    })
    bracket_nav.map('Q', {
        icon = icons.quickfix,
        next_desc = icons.quickfix .. 'Last quickfix item',
        prev_desc = icons.quickfix .. 'First quickfix item',
        next = command('clast'),
        prev = command('cfirst'),
    })
    bracket_nav.map('<C-q>', {
        icon = icons.quickfix,
        desc = 'quickfix file',
        next = command('cnfile'),
        prev = command('cpfile'),
    })
    bracket_nav.map('<M-q>', {
        icon = icons.quickfix,
        desc = 'quickfix list',
        next = command('cnewer'),
        prev = command('colder'),
    })
    bracket_nav.map('l', {
        icon = icons.loclist,
        desc = 'loclist item',
        next = command('lnext'),
        prev = command('lprevious'),
    })
    bracket_nav.map('L', {
        icon = icons.loclist,
        next_desc = icons.loclist .. 'Last loclist item',
        prev_desc = icons.loclist .. 'First loclist item',
        next = command('llast'),
        prev = command('lfirst'),
    })
    bracket_nav.map('<C-l>', {
        icon = icons.loclist,
        desc = 'loclist file',
        next = command('lnfile'),
        prev = command('lpfile'),
    })
    bracket_nav.map('<M-l>', {
        icon = icons.loclist,
        desc = 'loclist list',
        next = command('lnewer'),
        prev = command('lolder'),
    })
end

setup_global_maps()
setup_bracket_nav(require('utils.bracket_nav'))
