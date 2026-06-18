vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldmethod = 'expr'

return {
    {
        'chrisgrieser/nvim-origami',
        event = 'BufReadPost',
        opts = {
            autoFold = {
                enabled = false,
            },
            foldKeymaps = {
                setup = false,
            },
        },
        keys = {
            {
                'j',
                function()
                    require('origami').h()
                end,
                desc = ' Close fold context',
            },
            {
                ';',
                function()
                    require('origami').l()
                end,
                desc = ' Open fold context',
            },
        },
    },
}
