local adapters = {
    'codelldb',
    'debugpy',
    'bashdb',
    'js',
    'lua',
}

for _, adapter in ipairs(adapters) do
    require('config.dap.adapters.' .. adapter)
end
