return {
    {
        'copilotlsp-nvim/copilot-lsp',
        cmd = { 'CopilotLspSignIn', 'CopilotLspSignInDevice' },
        event = 'InsertEnter',
        init = function()
            vim.g.copilot_nes_debounce = 500
        end,
        opts = {
            nes = {
                move_count_threshold = 3,
            },
        },
        config = function(_, opts)
            require('copilot-lsp').setup(opts)
            vim.lsp.config('copilot_ls', {
                handlers = require('utils.copilot_nes').handlers(),
            })
            vim.lsp.enable('copilot_ls')
            vim.api.nvim_create_user_command('CopilotLspSignIn', function()
                require('utils.copilot_nes').sign_in()
            end, {
                desc = 'Sign in to GitHub Copilot LSP via gh',
            })
            vim.api.nvim_create_user_command('CopilotLspSignInDevice', function()
                require('utils.copilot_nes').sign_in_device()
            end, {
                desc = 'Sign in to GitHub Copilot LSP with device flow',
            })
        end,
        keys = {
            {
                '<Tab>',
                function()
                    return require('utils.copilot_nes').jump_or_apply_expr()
                end,
                mode = 'n',
                expr = true,
                desc = ' Goto/apply Copilot NES',
            },
        },
    },
}
