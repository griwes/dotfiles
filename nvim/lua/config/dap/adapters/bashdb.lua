local util = require('utils.dap_adapters')

local dap = require('dap')
local package_path = util.mason_package_path('bash-debug-adapter')
local bashdb_dir = package_path and vim.fs.joinpath(package_path, 'extension', 'bashdb_dir')

dap.adapters.bashdb = {
    type = 'executable',
    command = util.executable('bash-debug-adapter', 'bash-debug-adapter', 'bash-debug-adapter'),
}

local configuration = {
    name = 'Bash: Launch file',
    type = 'bashdb',
    request = 'launch',
    program = '${file}',
    cwd = '${fileDirname}',
    pathBash = vim.fn.exepath('bash') ~= '' and vim.fn.exepath('bash') or 'bash',
    pathCat = vim.fn.exepath('cat') ~= '' and vim.fn.exepath('cat') or 'cat',
    pathMkfifo = vim.fn.exepath('mkfifo') ~= '' and vim.fn.exepath('mkfifo') or 'mkfifo',
    pathPkill = vim.fn.exepath('pkill') ~= '' and vim.fn.exepath('pkill') or 'pkill',
    env = {},
    args = {},
    terminalKind = 'integrated',
}

if bashdb_dir then
    configuration.pathBashdb = vim.fs.joinpath(bashdb_dir, 'bashdb')
    configuration.pathBashdbLib = bashdb_dir
end

util.extend_configurations({ 'sh', 'bash' }, { configuration })
