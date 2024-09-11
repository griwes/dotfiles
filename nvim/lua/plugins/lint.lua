return {
    {
        'mfussenegger/nvim-lint',
        event = 'VeryLazy',
        config = function()
            require('lint').linters_by_ft = setmetatable({
                common = {},
                per_ft = {
                    gitcommit = { 'commitlint', 'gitlint', },
                }
            }, {
                __index = function(self, index)
                    return vim.tbl_flatten({ self.common, self.per_ft[index] or {} })
                end,
            })

            vim.api.nvim_create_augroup('NvimLint', { clear = true })
            vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
                group = 'NvimLint',
                callback = function()
                    require('lint').try_lint()
                end,
            })
        end,
    },
}
