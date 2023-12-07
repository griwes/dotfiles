-- general options
vim.opt.wrap = true
vim.opt.showmode = true
vim.opt.termguicolors = true

-- mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = "extend"
vim.opt.mousemoveevent = true
vim.opt.mousescroll = 'ver:15,hor:6'

-- sidebar options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"

-- search options
vim.opt.showmatch = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 4
vim.opt.smartindent = true

-- history options
vim.opt.undolevels = 16384
vim.opt.undofile = true

-- make updates on cursor hold faster
vim.opt.updatetime = 333

-- stable splits
vim.opt.splitkeep = 'screen'

-- some transparency
vim.opt.pumblend = 30

-- TODO: move to its own file
-- TODO: also split the autocmd
vim.cmd [[
    highlight default link cStructure Keyword
    highlight default link cppStructure Keyword
    highlight default link cStorageClass Keyword
    highlight default link cppStorageClass Keyword

    autocmd Syntax c syn keyword cStaticAssert static_assert
    autocmd Syntax cpp syn keyword cppStaticAssert static_assert

    highlight default link cStaticAssert Keyword
    highlight default link cppStaticAssert Keyword

    highlight default link cppOperator cLabel

    autocmd TermOpen * setlocal scrollback=-1

    autocmd WinEnter * setlocal virtualedit=
    autocmd WinEnter * set shortmess=F
]]

vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = '*',
    callback = function(args)
        if args.relative ~= '' then
            vim.opt.winblend = vim.g.neovide and 75 or 30
        end
    end
})

vim.api.nvim_create_autocmd({ 'SafeState' }, {
    pattern = '*',
    callback = function(args)
        vim.opt_local.textwidth = vim.fn.max({vim.fn.max(
            vim.tbl_map(
                function(x) return #x end,
                vim.api.nvim_buf_get_lines(0, 0, -1, false))),
            150})
    end,
})
vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = 'textwidth',
    callback = function(_)
        require('windows')
    end
})

-- leader
vim.g.mapleader = ','

-- allow more tabs, will be useful with tabulature
vim.g.tabpagemax = 750

vim.opt.laststatus = 3
