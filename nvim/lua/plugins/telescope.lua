local telescope = require('telescope')

telescope.setup({
    extensions = {
        undo = {
        },
        advanced_git_search = {
            diff_plugin = 'diffview',
        },
    }
})

vim.cmd [[ highlight TelescopeBorder guifg=#7ad5d6 ]]

telescope.load_extension('menufacture')
telescope.load_extension('undo')
telescope.load_extension('dap')
telescope.load_extension('persisted')
telescope.load_extension('advanced_git_search')

