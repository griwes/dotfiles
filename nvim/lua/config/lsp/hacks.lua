local function redefine_clangd_normal()
    vim.lsp.config('clangd', {
        cmd = {
            'clangd',
            '--all-scopes-completion',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--header-insertion=never',
        },
    })
end

local function redefine_clangd_cccl_devcontainer()
    local build = vim.fs.joinpath(vim.uv.cwd(), 'build')
    local latest_path = vim.uv.fs_readlink(vim.fs.joinpath(build, 'latest'))
    if not latest_path then
        vim.notify('config.lsp.hacks: can\'t find latest build dir')
        return
    end
    local latest = vim.fs.basename(latest_path)

    vim.lsp.config('clangd', {
        cmd = {
            'devcontainer',
            'exec',
            '--workspace-folder',
            '.',
            '--config',
            vim.fs.joinpath('.devcontainer', latest, 'devcontainer.json'),
            '--',
            'clangd',
            '--all-scopes-completion',
            '--background-index',
            '--clang-tidy',
            '--completion-style=detailed',
            '--header-insertion=never',
            '--path-mappings=' .. vim.uv.cwd() .. '=/home/coder/cccl',
        },
    })
end

local function apply_clangd_cmd_override()
    if #vim.api.nvim_get_runtime_file('lsp/clangd.lua', true) == 0 then
        return false
    end

    if vim.startswith(assert(vim.uv.cwd()), '/home/griwes/work/cccl') then
        redefine_clangd_cccl_devcontainer()
    else
        redefine_clangd_normal()
    end

    return true
end

local function override_clangd_cmd()
    if apply_clangd_cmd_override() then
        return
    end

    local group_name = 'LspClangdCmdOverride'
    local group = vim.api.nvim_create_augroup(group_name, { clear = true })

    local function callback()
        if not apply_clangd_cmd_override() then
            return
        end
        pcall(vim.api.nvim_del_augroup_by_name, group_name)
    end

    vim.api.nvim_create_autocmd('OptionSet', {
        group = group,
        pattern = 'runtimepath',
        callback = callback,
    })

    vim.api.nvim_create_autocmd('VimEnter', {
        group = group,
        once = true,
        callback = callback,
    })
end

override_clangd_cmd()
