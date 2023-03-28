vim.g.mapleader = ','

vim.keymap.set('n', 'j', 'h')
vim.keymap.set('n', 'k', 'gj')
vim.keymap.set('n', 'l', 'gk')
vim.keymap.set('n', ';', 'l')

vim.keymap.set('n', '<C-w>j', '<C-w>h')
vim.keymap.set('n', '<C-w>k', '<C-w>j')
vim.keymap.set('n', '<C-w>l', '<C-w>k')
vim.keymap.set('n', '<C-w>;', '<C-w>l')

vim.keymap.set('v', '.', '<C-c>.')

vim.keymap.set('n', '<C-s>', '<C-u>')
