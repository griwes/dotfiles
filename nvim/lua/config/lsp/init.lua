local function apply_project_settings(_, config)
    if not config.name then
        return
    end

    local ok, codesettings = pcall(require, 'codesettings')
    if not ok then
        return
    end

    local opts = {}
    if config.root_dir then
        opts.root_dir = config.root_dir
    end

    local merged = codesettings.with_local_settings(config.name, config, opts)
    for key, value in pairs(merged) do
        config[key] = value
    end
end

vim.lsp.config('*', {
    capabilities = require('utils.lsp_capabilities').get(),
    before_init = apply_project_settings,
})

require('config.lsp.servers')
require('config.lsp.inlay_hints')
require('config.lsp.keymaps')
