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

-- better wrapping
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:4'
vim.opt.linebreak = true

-- history options
vim.opt.undolevels = 16384
vim.opt.undofile = true

-- make updates on cursor hold faster
vim.opt.updatetime = 300

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

local target_winblend = vim.g.neovide and 66 or 0

vim.api.nvim_create_autocmd({ 'OptionSet' }, {
    pattern = '*',
    callback = function(_)
        vim.opt.winblend = target_winblend
    end
})

-- leader
vim.g.mapleader = ','
vim.g.localleader = ','

-- allow more tabs, will be useful with tabulature
vim.g.tabpagemax = 1000

vim.opt.laststatus = 3
vim.opt.guifont = 'IosevkaCustom Nerd Font Light:h10:#h-slight:#e-subpixelantialias'

vim.g.neovide_transparency = 0.85
vim.g.neovide_underline_stroke_scale = 0.5
vim.g.neovide_cursor_animation_length = 0.02
vim.g.neovide_scroll_animation_length = 0.15

vim.g.neovide_floating_blur_amount_x = 2.5
vim.g.neovide_floating_blur_amount_y = 2.5
