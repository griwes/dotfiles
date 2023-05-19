vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals'

require('persisted').setup({
    use_git_branch = true,
    autoload = true,
})

