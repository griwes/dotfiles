local function crates(method)
    return function()
        require('crates')[method]()
    end
end

return {
    {
        'saecki/crates.nvim',
        event = { 'BufRead Cargo.toml' },
        opts = {
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
            popup = {
                autofocus = true,
                border = 'rounded',
            },
        },
        cmd = 'Crates',
        keys = {
            { 'gCv', crates('show_versions_popup'), desc = '󰏗 Crate versions' },
            { 'gCf', crates('show_features_popup'), desc = '󰏗 Crate features' },
            { 'gCd', crates('show_dependencies_popup'), desc = '󰏗 Crate dependencies' },

            { 'gCu', crates('update_crate'), desc = '󰚰 Update crate' },
            { 'gCs', crates('update_crates'), desc = '󰚰 Update workspace crates' },
            { 'gCa', crates('update_all_crates'), desc = '󰚰 Update all crates' },
            { 'gCU', crates('upgrade_crate'), desc = '󰚰 Upgrade crate' },
            { 'gCS', crates('upgrade_crates'), desc = '󰚰 Upgrade workspace crates' },
            { 'gCA', crates('upgrade_all_crates'), desc = '󰚰 Upgrade all crates' },

            { 'gCx', crates('expand_plain_crate_to_inline_table'), desc = '󰚔 Expand crate inline table' },
            { 'gCX', crates('extract_crate_into_table'), desc = '󰚔 Extract crate to table' },

            { 'gCH', crates('open_homepage'), desc = '󰖟 Open crate homepage' },
            { 'gCR', crates('open_repository'), desc = ' Open crate repository' },
            { 'gCD', crates('open_documentation'), desc = '󰈙 Open crate documentation' },
            { 'gCC', crates('open_crates_io'), desc = '󰏗 Open crates.io page' },
            { 'gCL', crates('open_lib_rs'), desc = '󰈙 Open lib.rs page' },
        },
    },
    {
        'alexpasmantier/krust.nvim',
        ft = 'rust',
    },
}
