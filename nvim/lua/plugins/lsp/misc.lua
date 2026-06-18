return {
    {
        -- TODO: configure keybinds
        'smjonas/inc-rename.nvim',
        opts = {},
        keys = {
            { 'gln', ':IncRename <C-r><C-w>', desc = '󰑕 LSP incremental rename' },
        },
    },
    {
        'j-hui/fidget.nvim',
        event = 'LspAttach',
        opts = {
            progress = {
                suppress_on_insert = true,
                display = {
                    render_limit = 5,
                },
            },
            notification = {
                window = {
                    normal_hl = 'NormalFloat',
                    winblend = vim.g.neovide and 66 or 70,
                    align = 'top',
                },
            },
        },
    },
    {
        'artemave/workspace-diagnostics.nvim',
        keys = {
            {
                'hdx',
                function()
                    require('utils.lsp_workspace_diagnostics').populate(0)
                end,
                desc = '󰒡 Populate workspace diagnostics',
            },
        },
    },
}
