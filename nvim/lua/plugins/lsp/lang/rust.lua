return {
    {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
            lsp = {
                enabled = true,
                on_attach = function(client, bufnr)
                    require('utils.lsp').attach_callbacks(client, bufnr)
                end,
                actions = true,
                completion = true,
                hover = true,
            },
            popup = {
                autofocus = true,
                border = 'rounded',
            }
        },
        cmd = 'Crates',
        keys = {
            { '<leader>lcrv', '<cmd>Crates show_versions_popup<cr>' },
            { '<leader>lcrf', '<cmd>Crates show_features_popup<cr>' },
            { '<leader>lcrd', '<cmd>Crates show_dependencies_popup<cr>' },

            { '<leader>lcru', '<cmd>Crates update_crate<cr>' },
            { '<leader>lcru', '<cmd>Crates update_crates<cr>' },
            { '<leader>lcra', '<cmd>Crates update_all_crates<cr>' },
            { '<leader>lcrU', '<cmd>Crates upgrade_crate<cr>' },
            { '<leader>lcrU', '<cmd>Crates upgrade_crates<cr>' },
            { '<leader>lcrA', '<cmd>Crates upgrade_all_crates<cr>' },

            { '<leader>lcrx', '<cmd>Crates expand_plain_crate_to_inline_table<cr>' },
            { '<leader>lcrX', '<cmd>Crates extract_crate_into_table<cr>' },

            { '<leader>lcrH', '<cmd>Crates open_homepage<cr>' },
            { '<leader>lcrR', '<cmd>Crates open_repository<cr>' },
            { '<leader>lcrD', '<cmd>Crates open_documentation<cr>' },
            { '<leader>lcrC', '<cmd>Crates open_crates_io<cr>' },
            { '<leader>lcrL', '<cmd>Crates open_lib_rs<cr>' },
        }
    }
}
