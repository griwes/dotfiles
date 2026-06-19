return {
    {
        'mrjones2014/codesettings.nvim',
        lazy = false,
        opts = {
            -- Lazydev owns LuaLS workspace/library policy; keep codesettings
            -- focused on project settings and JSON schema support.
            lua_ls_integration = false,
        },
    },
}
