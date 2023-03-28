local telescope = require('telescope')

telescope.setup({
    extensions = {
        undo = {
        }
    }
})

vim.cmd [[ highlight TelescopeBorder guifg=#7ad5d6 ]]

telescope.load_extension('undo')
telescope.load_extension('dap')
