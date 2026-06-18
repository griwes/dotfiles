vim.lsp.config('*', {
    capabilities = require('utils.lsp_capabilities').get(),
})

require('config.lsp.servers')
require('config.lsp.inlay_hints')
require('config.lsp.keymaps')
