return {
    {
        'simrat39/rust-tools.nvim',
        lazy = false,
        config = function()
            local utils = require('utils.lsp')
            require('rust-tools').setup({
                server = {
                    on_attach = function(client, bufnr)
                        utils.attach_callbacks('rust', client, bufnr)
                    end,
                    capabilities = utils.get_capabilities(),
                },
                tools = {
                    inlay_hints = {
                        auto = false,
                    },
                },
            })
        end
    },
}
