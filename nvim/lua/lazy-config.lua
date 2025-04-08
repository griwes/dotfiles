-- bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local original_loadfile = loadfile
_G.loadfile = function(filename, mode, env)
    --- @diagnostic disable-next-line: need-check-nil
    return original_loadfile(filename, mode, env)
end

require('lazy').setup('plugins', {
    ui = {
        border = 'rounded',
        title = 'Lazy',
    },
    diff = {
        cmd = 'diffview.nvim',
    },
    checker = {
        enabled = true,
    },
})
