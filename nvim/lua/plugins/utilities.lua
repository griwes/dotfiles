require('compiler-explorer').setup({
    autocmd = {
        enable = true,
    },
    diagnostics = {
        virtual_text = true,
    }
})

require('femaco').setup({
})

require('swap-split').setup({
    ignore_filetypes = {
        'NvimTree'
    }
})

require('deferred-clipboard').setup({
    fallback = 'unnamedplus',
    lazy = true,
})

require('numb').setup({
    number_only = true,
})

require('buffercd').setup({
})

require('nvim-surround').setup({
})

require('typo').setup({
})

require("early-retirement").setup({
})
