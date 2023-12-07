vim.keymap.set({'n', 'v', 'o'}, 'j', 'h', { noremap = true })
vim.keymap.set({'n', 'v', 'o'}, 'k', 'gj', { noremap = true })
vim.keymap.set({'n', 'v', 'o'}, 'l', 'gk', { noremap = true })
vim.keymap.set({'n', 'v', 'o'}, ';', 'l', { noremap = true })

vim.keymap.set({'n', 'v'}, '<C-w>j', '<C-w>h')
vim.keymap.set({'n', 'v'}, '<C-w>k', '<C-w>j')
vim.keymap.set({'n', 'v'}, '<C-w>l', '<C-w>k')
vim.keymap.set({'n', 'v'}, '<C-w>;', '<C-w>l')

vim.keymap.set('v', '.', '<C-c>.')

vim.keymap.set('n', '<C-s>', '<C-u>')

vim.keymap.set({'n', 'v'}, 'w', "<cmd>lua require('spider').motion('w')<CR>", { desc = 'Spider-w' })
vim.keymap.set({'n', 'v'}, 'e', "<cmd>lua require('spider').motion('e')<CR>", { desc = 'Spider-e' })
vim.keymap.set({'n', 'v'}, 'b', "<cmd>lua require('spider').motion('b')<CR>", { desc = 'Spider-b' })
vim.keymap.set({'n', 'v'}, 'ge', "<cmd>lua require('spider').motion('ge')<CR>", { desc = 'Spider-ge' })
