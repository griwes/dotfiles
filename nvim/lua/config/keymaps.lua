local function del(mode, lhs)
    pcall(vim.keymap.del, mode, lhs)
end

-- Neovim and a few plugins create default maps in namespaces that this config
-- intentionally owns. Clear them on startup so the explicit schema below wins.
local function cleanup_stale_keymaps()
    for _, lhs in ipairs({
        'grn',
        'gra',
        'grx',
        'grr',
        'gri',
        'grt',
        'gO',
        'glm',
        'gI',
        'glC',
        'hda',
        'hdl',
        'htn',
        'htm',
        'gs',
        'gS',
        'gq',
        '[F',
        ']F',
    }) do
        del('n', lhs)
    end

    for _, lhs in ipairs({ 'gra', 'gs', 'gS', 'hda', 'hdl', 'htn', 'htm' }) do
        del('x', lhs)
    end

    for _, lhs in ipairs({ 'gra', 'gs', 'gS', 'gq' }) do
        del('o', lhs)
    end
end

cleanup_stale_keymaps()

vim.keymap.set({ 'n', 'x', 'o' }, 'gm', '<Nop>', { desc = 'Reserved structural move prefix' })
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Nop>', { desc = 'Reserved structural swap prefix' })

local bracket_nav = require('utils.bracket_nav')
local diagnostics = require('utils.diagnostics')

bracket_nav.setup({
    next_repeat = '<M-]>',
    prev_repeat = '<M-[>',
})

require('config.quickfix')

local function command(cmd)
    return function()
        vim.cmd(cmd)
    end
end

local function normal(keys)
    return function()
        vim.cmd.normal({ args = { keys }, bang = true })
    end
end

bracket_nav.map('d', {
    mode = { 'n', 'x', 'o' },
    icon = diagnostics.icons.diagnostics,
    desc = 'diagnostic',
    next = function()
        vim.diagnostic.jump({ count = 1, float = false })
    end,
    prev = function()
        vim.diagnostic.jump({ count = -1, float = false })
    end,
})
bracket_nav.map('e', {
    mode = { 'n', 'x', 'o' },
    icon = diagnostics.icons.error,
    desc = 'error',
    next = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, float = false })
    end,
    prev = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, float = false })
    end,
})
bracket_nav.map('w', {
    mode = { 'n', 'x', 'o' },
    icon = diagnostics.icons.warn,
    desc = 'warning',
    next = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1, float = false })
    end,
    prev = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1, float = false })
    end,
})
bracket_nav.map('i', {
    mode = { 'n', 'x', 'o' },
    icon = diagnostics.icons.info,
    desc = 'info diagnostic',
    next = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = 1, float = false })
    end,
    prev = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.INFO, count = -1, float = false })
    end,
})
bracket_nav.map('H', {
    mode = { 'n', 'x', 'o' },
    icon = diagnostics.icons.hint,
    desc = 'hint diagnostic',
    next = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = 1, float = false })
    end,
    prev = function()
        vim.diagnostic.jump({ severity = vim.diagnostic.severity.HINT, count = -1, float = false })
    end,
})

bracket_nav.map('b', {
    icon = ' ',
    desc = 'buffer',
    next = command('bnext'),
    prev = command('bprevious'),
})
bracket_nav.map('B', {
    icon = ' ',
    next_desc = ' Last buffer',
    prev_desc = ' First buffer',
    next = command('blast'),
    prev = command('bfirst'),
})
bracket_nav.map('z', {
    mode = { 'n', 'x', 'o' },
    icon = ' ',
    desc = 'fold',
    next = normal('zj'),
    prev = normal('zk'),
})
bracket_nav.map('s', {
    mode = { 'n', 'x', 'o' },
    icon = '󰓆 ',
    desc = 'spell error',
    next = normal(']s'),
    prev = normal('[s'),
})
bracket_nav.map('\'', {
    icon = '󰃀 ',
    desc = 'lowercase mark',
    next = normal(']`'),
    prev = normal('[`'),
})
bracket_nav.map('<Tab>', {
    icon = '󰓩 ',
    desc = 'tab',
    next = command('tabnext'),
    prev = command('tabprevious'),
})
bracket_nav.map('<S-Tab>', {
    icon = '󰓩 ',
    next_desc = '󰓩 Last tab',
    prev_desc = '󰓩 First tab',
    next = command('tablast'),
    prev = command('tabfirst'),
})

vim.keymap.set({ 'n', 'v', 'o' }, 'j', 'h', { noremap = true, desc = 'Move left' })
vim.keymap.set({ 'n', 'v', 'o' }, 'k', 'gj', { noremap = true, desc = 'Move down by screen line' })
vim.keymap.set({ 'n', 'v', 'o' }, 'l', 'gk', { noremap = true, desc = 'Move up by screen line' })
vim.keymap.set({ 'n', 'v', 'o' }, ';', 'l', { noremap = true, desc = 'Move right' })

vim.keymap.set({ 'n', 'v' }, '<C-w>j', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set({ 'n', 'v' }, '<C-w>k', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set({ 'n', 'v' }, '<C-w>l', '<C-w>k', { desc = 'Move to upper window' })
vim.keymap.set({ 'n', 'v' }, '<C-w>;', '<C-w>l', { desc = 'Move to right window' })

vim.keymap.set('v', '.', '<C-c>.', { desc = 'Repeat last normal command' })

vim.keymap.set('n', '<C-s>', '<C-u>', { desc = 'Scroll up half page' })

vim.keymap.set({ 'n', 'v', 'o' }, 'h', '<Nop>', { desc = 'Reserved preview/action prefix' })

vim.keymap.set({ 'n', 'v' }, 'gu', '<Nop>', { desc = 'Disabled lowercase operator' })
vim.keymap.set({ 'n', 'v' }, 'gU', '<Nop>', { desc = 'Disabled uppercase operator' })
