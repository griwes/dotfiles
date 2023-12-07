return {
    {
        -- TODO: configure bookmark groups to give them some sort of meaning?
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {
            builtin_marks = { ".", "<", ">", "^" },
            excluded_filetypes = {
                'dropbar_menu',
            },
        },
    },
}

