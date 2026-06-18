local M = {}

-- Shared DAP adapter helpers for side-effectful adapter config modules.

function M.mason_package_path(package_name)
    local ok, registry = pcall(require, 'mason-registry')
    if not ok then
        return nil
    end

    local package_ok, package = pcall(registry.get_package, package_name)
    if not package_ok or not package:is_installed() then
        return nil
    end

    return package:get_install_path()
end

function M.executable(command, package_name, relative_path)
    if package_name then
        local package_path = M.mason_package_path(package_name)
        if package_path then
            return vim.fs.joinpath(package_path, relative_path or command)
        end
    end

    local mason_bin = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'bin', command)
    if vim.uv.fs_stat(mason_bin) then
        return mason_bin
    end

    local from_path = vim.fn.exepath(command)
    if from_path ~= '' then
        return from_path
    end

    return command
end

function M.input_args(prompt)
    local args = vim.fn.input(prompt or 'Args: ')
    if args == '' then
        return {}
    end

    return vim.split(args, '%s+', { trimempty = true })
end

function M.input_port(prompt, default)
    local port = vim.fn.input(prompt, default)
    return tonumber(port) or tonumber(default)
end

function M.python_path()
    local venv = vim.env.VIRTUAL_ENV or vim.env.CONDA_PREFIX
    if venv and venv ~= '' then
        return vim.fs.joinpath(venv, 'bin', 'python')
    end

    local python3 = vim.fn.exepath('python3')
    if python3 ~= '' then
        return python3
    end

    local python = vim.fn.exepath('python')
    if python ~= '' then
        return python
    end

    return 'python'
end

function M.lua_path()
    local luajit = vim.fn.exepath('luajit')
    if luajit ~= '' then
        return luajit
    end

    local lua = vim.fn.exepath('lua')
    if lua ~= '' then
        return lua
    end

    return 'lua'
end

function M.lldb_quote(value)
    return '\'' .. tostring(value):gsub('\'', '\'\\\'\'') .. '\''
end

function M.extend_configurations(filetypes, configurations)
    local dap = require('dap')

    for _, filetype in ipairs(filetypes) do
        local existing_configurations = dap.configurations[filetype] or {}

        for _, configuration in ipairs(configurations) do
            existing_configurations = vim.tbl_filter(function(existing)
                return existing.name ~= configuration.name
                    or existing.type ~= configuration.type
                    or existing.request ~= configuration.request
            end, existing_configurations)
            table.insert(existing_configurations, vim.deepcopy(configuration))
        end

        dap.configurations[filetype] = existing_configurations
    end
end

return M
