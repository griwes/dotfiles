vim.g.mapleader = ','

vim.keymap.set({'n', 'v'}, 'j', 'h')
vim.keymap.set({'n', 'v'}, 'k', 'gj')
vim.keymap.set({'n', 'v'}, 'l', 'gk')
vim.keymap.set({'n', 'v'}, ';', 'l')

vim.keymap.set({'n', 'v'}, '<C-w>j', '<C-w>h')
vim.keymap.set({'n', 'v'}, '<C-w>k', '<C-w>j')
vim.keymap.set({'n', 'v'}, '<C-w>l', '<C-w>k')
vim.keymap.set({'n', 'v'}, '<C-w>;', '<C-w>l')

vim.keymap.set('v', '.', '<C-c>.')

vim.keymap.set('n', '<C-s>', '<C-u>')

vim.keymap.set('n', '<C-p>', ':Telescope find_files<cr>')
vim.keymap.set('n', '<C-b>', ':Telescope buffers<cr>')
vim.keymap.set('n', '<C-t>', ':Telescope<cr>')

vim.keymap.set({'n', 'o', 'x'}, 'w', "<cmd>lua require('spider').motion('w')<CR>", { desc = 'Spider-w' })
vim.keymap.set({'n', 'o', 'x'}, 'e', "<cmd>lua require('spider').motion('e')<CR>", { desc = 'Spider-e' })
vim.keymap.set({'n', 'o', 'x'}, 'b', "<cmd>lua require('spider').motion('b')<CR>", { desc = 'Spider-b' })
vim.keymap.set({'n', 'o', 'x'}, 'ge', "<cmd>lua require('spider').motion('ge')<CR>", { desc = 'Spider-ge' })

vim.keymap.set({'v', 'o', 'x'}, '<Leader>f', '<cmd>HopChar1<CR>')
vim.keymap.set('n', '<Leader>f', '<cmd>HopChar1MW<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>s', '<cmd>HopChar2<CR>')
vim.keymap.set('n', '<Leader>s', '<cmd>HopChar2MW<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>w', '<cmd>HopWord<CR>')
vim.keymap.set('n', '<Leader>w', '<cmd>HopWordMW<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>L', '<cmd>HopLine<CR>')
vim.keymap.set('n', '<Leader>L', '<cmd>HopLineMW<CR>')

vim.keymap.set({'n', 'v', 'o', 'x'}, '<Leader>/', '<cmd>HopPattern<CR>')

vim.keymap.set({'v', 'o', 'x'}, '<Leader>;', '<cmd>HopWordCurrentLineAC<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>l', '<cmd>HopVerticalBC<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>k', '<cmd>HopVerticalAC<CR>')
vim.keymap.set({'v', 'o', 'x'}, '<Leader>j', '<cmd>HopWordCurrentLineBC<CR>')
