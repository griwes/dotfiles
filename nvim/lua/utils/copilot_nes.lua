local M = {}

-- Copilot NES helpers used by plugin specs and keymaps.

local methods = {
    did_change_status = 'didChangeStatus',
    sign_in = 'signIn',
    sign_in_with_github_token = 'signInWithGithubToken',
}

local gh_sign_in_pending = false
local auto_gh_sign_in_attempted = false

local function current_buf()
    return vim.api.nvim_get_current_buf()
end

local function copilot_client(bufnr)
    bufnr = bufnr or current_buf()
    return vim.lsp.get_clients({ name = 'copilot_ls', bufnr = bufnr })[1]
        or vim.lsp.get_clients({ name = 'copilot_ls' })[1]
end

local function notify(message, level)
    vim.notify(message, level, { title = 'Copilot LSP' })
end

local function trim(value)
    return (value or ''):gsub('^%s+', ''):gsub('%s+$', '')
end

local function run_gh(args, callback)
    if vim.fn.executable('gh') ~= 1 then
        vim.schedule(function()
            callback(nil, 'gh is not executable')
        end)
        return
    end

    local command = { 'gh' }
    vim.list_extend(command, args)

    vim.system(command, { text = true }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                callback(nil, trim(result.stderr) ~= '' and trim(result.stderr) or trim(result.stdout))
                return
            end

            callback(trim(result.stdout), nil)
        end)
    end)
end

local function request_device_sign_in(client, bufnr)
    client:request(methods.sign_in, vim.empty_dict(), nil, bufnr)
end

local function finish_failed_sign_in(opts, client, bufnr, message)
    gh_sign_in_pending = false
    vim.g.copilot_lsp_signin_pending = nil

    if opts.fallback_to_device then
        notify(message .. '; falling back to the Copilot device flow', vim.log.levels.WARN)
        request_device_sign_in(client, bufnr)
    elseif opts.notify_errors then
        notify(message, vim.log.levels.WARN)
    end
end

local function request_gh_sign_in(client, bufnr, opts)
    opts = opts or {}
    opts.notify_errors = opts.notify_errors ~= false

    if gh_sign_in_pending or vim.g.copilot_lsp_signin_pending then
        return true
    end

    gh_sign_in_pending = true
    vim.g.copilot_lsp_signin_pending = true

    run_gh({ 'auth', 'token', '-h', 'github.com' }, function(token, token_error)
        if token_error or token == '' then
            finish_failed_sign_in(opts, client, bufnr, 'Could not get a GitHub token from gh')
            return
        end

        run_gh({ 'api', 'user', '--jq', '.login' }, function(user, user_error)
            if user_error or user == '' then
                token = nil
                finish_failed_sign_in(opts, client, bufnr, 'Could not get the GitHub user from gh')
                return
            end

            client:request(methods.sign_in_with_github_token, {
                githubToken = token,
                user = user,
            }, function(error, result)
                token = nil
                gh_sign_in_pending = false
                vim.g.copilot_lsp_signin_pending = nil

                if error then
                    finish_failed_sign_in(opts, client, bufnr, 'Copilot rejected the gh GitHub token')
                    return
                end

                local status = type(result) == 'table' and result.status or result
                if status == 'OK' or status == 'MaybeOK' then
                    if opts.notify_success ~= false then
                        notify('Signed in as ' .. user .. ' via gh', vim.log.levels.INFO)
                    end
                    return
                end

                finish_failed_sign_in(opts, client, bufnr, 'Copilot sign-in via gh returned: ' .. vim.inspect(result))
            end, bufnr)
        end)
    end)

    return true
end

local function request_sign_in(client, bufnr, opts)
    opts = opts or {}
    opts.fallback_to_device = opts.fallback_to_device ~= false
    return request_gh_sign_in(client, bufnr, opts)
end

function M.has_pending(bufnr)
    bufnr = bufnr or current_buf()
    return vim.b[bufnr].nes_state ~= nil
end

function M.jump_or_apply(bufnr)
    bufnr = bufnr or current_buf()
    if not M.has_pending(bufnr) then
        return false
    end

    local ok, nes = pcall(require, 'copilot-lsp.nes')
    if not ok then
        return false
    end

    return nes.walk_cursor_start_edit(bufnr) or (nes.apply_pending_nes(bufnr) and nes.walk_cursor_end_edit(bufnr))
end

function M.jump_or_apply_expr()
    if M.jump_or_apply(current_buf()) then
        return ''
    end

    -- Preserve normal-mode <Tab>'s native jump-list behavior.
    return '<C-i>'
end

function M.clear()
    local ok, nes = pcall(require, 'copilot-lsp.nes')
    if not ok then
        return false
    end

    return nes.clear()
end

function M.sign_in(bufnr, opts)
    opts = opts or {}
    bufnr = bufnr or current_buf()
    local client = copilot_client(bufnr)
    if client then
        request_sign_in(client, bufnr, opts)
        return true
    end

    pcall(vim.lsp.enable, 'copilot_ls')
    vim.defer_fn(function()
        local retry = copilot_client(bufnr)
        if retry then
            request_sign_in(retry, bufnr, opts)
            return
        end

        notify('copilot_ls is not attached yet', vim.log.levels.WARN)
    end, 250)

    return true
end

function M.sign_in_device(bufnr)
    bufnr = bufnr or current_buf()
    local client = copilot_client(bufnr)
    if client then
        request_device_sign_in(client, bufnr)
        return true
    end

    pcall(vim.lsp.enable, 'copilot_ls')
    vim.defer_fn(function()
        local retry = copilot_client(bufnr)
        if retry then
            request_device_sign_in(retry, bufnr)
            return
        end

        notify('copilot_ls is not attached yet', vim.log.levels.WARN)
    end, 250)

    return true
end

function M.handlers()
    local ok, handlers = pcall(require, 'copilot-lsp.handlers')
    if not ok then
        return {}
    end

    local configured = vim.tbl_extend('force', {}, handlers)
    configured[methods.did_change_status] = function(error, result, context)
        if error or not result then
            return
        end

        if result.kind ~= 'Error' or not result.message:find('not signed into') then
            return
        end

        if auto_gh_sign_in_attempted then
            return
        end

        auto_gh_sign_in_attempted = true

        local client = vim.lsp.get_client_by_id(context.client_id)
        if not client then
            return
        end

        request_gh_sign_in(client, context.bufnr, {
            fallback_to_device = false,
            notify_errors = false,
            notify_success = true,
        })
    end

    return configured
end

return M
