-- general options
vim.opt.wrap = true
vim.opt.showmode = true
vim.opt.termguicolors = true

-- mouse
vim.opt.mouse = 'a'
vim.opt.mousemodel = "extend"

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

-- TODO: move to its own file
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
]]
