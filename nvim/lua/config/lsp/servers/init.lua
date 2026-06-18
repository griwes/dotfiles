local servers = {
    'clangd',
    'harper_ls',
    'neocmake',
    'ruff',
    'rust_analyzer',
    'yamlls',
}

for _, server in ipairs(servers) do
    require('config.lsp.servers.' .. server)
end
