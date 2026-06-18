return {
    {
        'johmsalas/text-case.nvim',
        opts = {
            default_keymappings_enabled = true,
            prefix = 'ga',
        },
        keys = {
            { 'ga', mode = { 'n', 'x' }, desc = '󰬴 Text case' },

            -- text-case.nvim's default quick conversions. They apply to the
            -- current word in normal mode and to the selection in visual mode.
            { 'gan', mode = { 'n', 'x' }, desc = '󰬴 Convert to TO_CONSTANT_CASE' },
            { 'gac', mode = { 'n', 'x' }, desc = '󰬴 Convert to toCamelCase' },
            { 'gas', mode = { 'n', 'x' }, desc = '󰬴 Convert to to_snake_case' },
            { 'gad', mode = { 'n', 'x' }, desc = '󰬴 Convert to to-dash-case' },
            { 'gap', mode = { 'n', 'x' }, desc = '󰬴 Convert to ToPascalCase' },
            { 'gau', mode = { 'n', 'x' }, desc = '󰬴 Convert to TO UPPER CASE' },
            { 'gal', mode = { 'n', 'x' }, desc = '󰬴 Convert to to lower case' },

            -- Operator-pending conversions: `gao{case}{motion}`.
            { 'gaon', mode = 'n', desc = '󰬴 Operator convert to TO_CONSTANT_CASE' },
            { 'gaoc', mode = 'n', desc = '󰬴 Operator convert to toCamelCase' },
            { 'gaos', mode = 'n', desc = '󰬴 Operator convert to to_snake_case' },
            { 'gaod', mode = 'n', desc = '󰬴 Operator convert to to-dash-case' },
            { 'gaop', mode = 'n', desc = '󰬴 Operator convert to ToPascalCase' },
            { 'gaou', mode = 'n', desc = '󰬴 Operator convert to TO UPPER CASE' },
            { 'gaol', mode = 'n', desc = '󰬴 Operator convert to to lower case' },

            -- LSP rename conversions for the symbol under the cursor.
            { 'gaN', mode = 'n', desc = '󰬴 LSP rename to TO_CONSTANT_CASE' },
            { 'gaC', mode = 'n', desc = '󰬴 LSP rename to toCamelCase' },
            { 'gaS', mode = 'n', desc = '󰬴 LSP rename to to_snake_case' },
            { 'gaD', mode = 'n', desc = '󰬴 LSP rename to to-dash-case' },
            { 'gaP', mode = 'n', desc = '󰬴 LSP rename to ToPascalCase' },
            { 'gaU', mode = 'n', desc = '󰬴 LSP rename to TO UPPER CASE' },
            { 'gaL', mode = 'n', desc = '󰬴 LSP rename to to lower case' },
        },
        cmd = {
            'Subs',
        },
    },
}
