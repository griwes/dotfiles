vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('CreateMissingParentDirs', { clear = true }),
    callback = function(event)
        if vim.bo[event.buf].buftype ~= '' or event.match == '' or event.match:match('^[%w+.-]+://') then
            return
        end

        local dir = vim.fn.fnamemodify(event.match, ':p:h')
        if dir ~= '' and vim.uv.fs_stat(dir) == nil then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    callback = function()
        vim.hl.hl_op()
    end,
})

vim.api.nvim_create_autocmd('TermOpen', {
    group = vim.api.nvim_create_augroup('TerminalPolicy', { clear = true }),
    callback = function()
        vim.opt_local.scrollback = -1
    end,
})

vim.api.nvim_create_autocmd('WinEnter', {
    group = vim.api.nvim_create_augroup('WindowPolicy', { clear = true }),
    callback = function()
        vim.opt_local.virtualedit = ''
        vim.opt.shortmess = 'F'
    end,
})

vim.api.nvim_create_autocmd('Syntax', {
    group = vim.api.nvim_create_augroup('SyntaxPolicy', { clear = true }),
    pattern = 'c',
    command = 'syn keyword cStaticAssert static_assert',
})

vim.api.nvim_create_autocmd('Syntax', {
    group = 'SyntaxPolicy',
    pattern = 'cpp',
    command = 'syn keyword cppStaticAssert static_assert',
})
