local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities['textDocument']['completion']['completionItem']['snippetSupport'] = false
capabilities['textDocument']['semanticTokens'] = { requests = { range = true, full = { delta = true }}}

local on_attach_callbacks = {}

local function add_callback(callback)
    on_attach_callbacks[#on_attach_callbacks + 1] = callback
end

local function attach_callbacks(language, client, bufnr)
    for index, callback in pairs(on_attach_callbacks)
    do
        callback(language, client, bufnr)
    end
end

add_callback(function(lang, client, bufnr)
    require('nvim-navic').attach(client, bufnr)
end)

require('illuminate').configure({
    delay = 500,
})

require('inc_rename').setup({
})

vim.cmd [[
    highlight DiagnosticVirtualTextError guibg=None
    highlight DiagnosticVirtualTextWarn guibg=None
    highlight DiagnosticVirtualTextInfo guibg=None
    highlight DiagnosticVirtualTextHint guibg=None
]]

require('lsp_lines').setup({
})
vim.diagnostic.config({
    virtual_text = false,
})

vim.cmd [[
    highlight default link @lsp.type.namespace @namespace
    highlight default link @lsp.type.variable @repeat
    highlight default link @lsp.type.property @property
    highlight! default link @lsp.type.parameter @repeat
    highlight default @lsp.type.concept guifg=LightGreen

    highlight default @lsp.mod.functionScope gui=italic
    highlight default @lsp.mod.dependentName guifg=#81b29a gui=italic

    highlight clear @lsp.typemod.function.defaultLibrary
    highlight clear @lsp.typemod.method.defaultLibrary
    highlight clear @lsp.typemod.variable.defaultLibrary
]]

add_callback(function(lang, client, bufnr)
    require('lsp-format-modifications').attach(client, bufnr, { format_on_save = true })
end)

require('nvim-lightbulb').setup({
    sign = {
        enabled = false
    },
    virtual_text = {
        enabled = true
    },
    autocmd = {
        enabled = true,
        events = { 'CursorHold', 'CursorHoldI' }
    }
})

require('clangd_extensions').setup({
    server = {
        cmd = {
            'clangd',
            [[--clang-tidy]], [[--completion-style=detailed]], [[--header-insertion=never]]
        },
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            attach_callbacks('c++', client, bufnr)
        end,
    },
})

-- rewrite with proper lua?
vim.cmd [[ autocmd TextChanged * lua require('clangd_extensions.inlay_hints').set_inlay_hints() ]]
vim.cmd [[ autocmd TextChangedI * lua require('clangd_extensions.inlay_hints').set_inlay_hints() ]]

require('rust-tools').setup({
    server = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            attach_callbacks('rust', client, bufnr)
        end,
    },
})

