vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,globals'

return {
    {
        -- TODO: configure keybinds
        'olimorris/persisted.nvim',
        lazy = false,
        config = function()
            require('persisted').setup({
                use_git_branch = true,
                autoload = true,
            })
        end
    },
}

