local function on_list(opts)
    vim.fn.setloclist(0, {}, ' ', opts)
    vim.cmd.lopen()
end

local function toggle_inlay_hints(bufnr)
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
end

local function set_keymaps(bufnr)
    local opts = { buffer = bufnr }

    vim.keymap.set('n', 'glh', function()
        toggle_inlay_hints(bufnr)
    end, vim.tbl_extend('force', opts, { desc = '󰧑 LSP toggle inlay hints' }))

    vim.keymap.set('n', 'glx', function()
        vim.lsp.codelens.run()
    end, vim.tbl_extend('force', opts, { desc = ' LSP run code lens' }))

    vim.keymap.set('n', 'hlr', function()
        vim.lsp.buf.references(nil, { loclist = true })
    end, vim.tbl_extend('force', opts, { desc = '󰈇 Preview LSP references' }))

    vim.keymap.set('n', 'hld', function()
        vim.lsp.buf.definition({ loclist = true, on_list = on_list })
    end, vim.tbl_extend('force', opts, { desc = '󰳽 Preview LSP definitions' }))

    vim.keymap.set('n', 'hlD', function()
        vim.lsp.buf.declaration({ loclist = true, on_list = on_list })
    end, vim.tbl_extend('force', opts, { desc = '󰳽 Preview LSP declarations' }))

    vim.keymap.set('n', 'hlt', function()
        vim.lsp.buf.type_definition({ loclist = true, on_list = on_list })
    end, vim.tbl_extend('force', opts, { desc = ' Preview LSP type definitions' }))

    vim.keymap.set('n', 'hli', function()
        vim.lsp.buf.implementation({ loclist = true, on_list = on_list })
    end, vim.tbl_extend('force', opts, { desc = '󰡱 Preview LSP implementations' }))

    vim.keymap.set('n', 'hlci', function()
        vim.lsp.buf.incoming_calls()
    end, vim.tbl_extend('force', opts, { desc = ' Preview LSP incoming calls' }))

    vim.keymap.set('n', 'hlco', function()
        vim.lsp.buf.outgoing_calls()
    end, vim.tbl_extend('force', opts, { desc = ' Preview LSP outgoing calls' }))
end

vim.api.nvim_create_augroup('LspKeymaps', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
    group = 'LspKeymaps',
    callback = function(args)
        set_keymaps(args.buf)
    end,
})
