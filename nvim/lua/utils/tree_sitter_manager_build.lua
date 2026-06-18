local M = {}

local state_version = 1

local function setup_plugin_path(plugin)
    if type(plugin) ~= 'table' or type(plugin.dir) ~= 'string' then
        return
    end

    if not vim.tbl_contains(vim.opt.rtp:get(), plugin.dir) then
        vim.opt.rtp:prepend(plugin.dir)
    end
end

local function state_path()
    return vim.fs.joinpath(vim.fn.stdpath('data'), 'tree-sitter-manager', 'parser-revisions.json')
end

local function read_state(path)
    if vim.uv.fs_stat(path) == nil then
        return { version = state_version, parsers = {} }
    end

    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok then
        return { version = state_version, parsers = {} }
    end

    local decode_ok, decoded = pcall(vim.json.decode, table.concat(lines, '\n'))
    if not decode_ok or type(decoded) ~= 'table' then
        return { version = state_version, parsers = {} }
    end

    decoded.version = decoded.version or state_version
    decoded.parsers = decoded.parsers or {}
    return decoded
end

local function write_state(path, state)
    vim.fn.mkdir(vim.fn.fnamemodify(path, ':h'), 'p')
    vim.fn.writefile({ vim.json.encode(state) }, path)
end

local function notify(message)
    if coroutine.running() then
        pcall(coroutine.yield, message)
    else
        vim.notify(message, vim.log.levels.INFO)
    end
end

local function install_record(lang, info, query_only)
    if query_only then
        return {
            kind = 'query',
            revision = 'query-only',
            fingerprint = 'query-only',
        }
    end

    local source = 'unversioned'
    local revision = 'unversioned'
    if info.revision then
        source = 'revision'
        revision = info.revision
    elseif info.branch then
        source = 'branch'
        revision = info.branch
    end

    return {
        kind = 'parser',
        source = source,
        revision = revision,
        url = info.url,
        location = info.location or lang,
        generate = info.generate or false,
        queries = info.queries or 'queries',
        use_repo_queries = info.use_repo_queries or false,
        fingerprint = table.concat({
            info.url or '',
            info.location or lang,
            source,
            revision,
            tostring(info.generate or false),
            info.queries or 'queries',
            tostring(info.use_repo_queries or false),
        }, '\31'),
    }
end

local function records_match(a, b)
    return type(a) == 'table' and a.fingerprint == b.fingerprint
end

function M.update_all(plugin, opts)
    opts = opts or {}
    setup_plugin_path(plugin)

    local config = require('tree-sitter-manager.config')
    local installer = require('tree-sitter-manager.installer')
    local util = require('tree-sitter-manager.util')
    local path = state_path()
    local state = read_state(path)
    local summary = {
        installed = {},
        updated = {},
        adopted = {},
        skipped = {},
        failed = {},
    }
    local visiting = {}
    local visited = {}

    vim.fn.mkdir(config.cfg.parser_dir, 'p')
    vim.fn.mkdir(config.cfg.query_dir, 'p')

    local function is_installed(lang, query_only)
        if query_only then
            return vim.uv.fs_stat(util.qpath(lang)) ~= nil
        end
        if vim.uv.fs_stat(util.ppath(lang)) == nil then
            return false
        end
        if vim.uv.fs_stat(vim.fs.joinpath(util.PLUGIN_ROOT, 'runtime/queries', lang)) == nil then
            return true
        end
        return vim.uv.fs_stat(util.qpath(lang)) ~= nil
    end

    local function install_with_manager(lang)
        local done = false
        local result = false

        installer.install(lang, function(ok)
            result = ok == true
            done = true
        end)

        local waited = vim.wait(opts.timeout_ms or 300000, function()
            return done
        end, 100)

        return waited and result
    end

    local function handle(lang)
        if visited[lang] then
            return true
        end
        if visiting[lang] then
            summary.failed[#summary.failed + 1] = lang .. ': circular dependency'
            return false
        end
        if not config.effective_repos[lang] then
            summary.failed[#summary.failed + 1] = lang .. ': unknown parser'
            return false
        end

        visiting[lang] = true
        for _, dep in ipairs(installer.get_requires(lang)) do
            if not handle(dep) then
                visiting[lang] = nil
                return false
            end
        end
        visiting[lang] = nil

        local info = installer.get_repo_info(lang)
        local query_only = installer.is_only_query(lang)
        local record = install_record(lang, info, query_only)
        local existing = state.parsers[lang]
        local installed = is_installed(lang, query_only)

        if installed and existing == nil then
            summary.adopted[#summary.adopted + 1] = lang
            if not opts.dry_run then
                state.parsers[lang] = record
                write_state(path, state)
            end
            visited[lang] = true
            return true
        end

        local action = nil
        if not installed then
            action = 'install'
        elseif not records_match(existing, record) then
            action = 'update'
        end

        if action == nil then
            summary.skipped[#summary.skipped + 1] = lang
            visited[lang] = true
            return true
        end

        if opts.dry_run then
            local bucket = action == 'install' and summary.installed or summary.updated
            bucket[#bucket + 1] = lang
            visited[lang] = true
            return true
        end

        notify(string.format('%s %s', action == 'install' and 'Installing' or 'Updating', lang))
        if action == 'update' then
            installer.remove(lang)
        end

        local ok = install_with_manager(lang)
        if not ok then
            summary.failed[#summary.failed + 1] = lang .. ': manager install failed or timed out'
            return false
        end

        state.parsers[lang] = record
        write_state(path, state)
        local bucket = action == 'install' and summary.installed or summary.updated
        bucket[#bucket + 1] = lang
        visited[lang] = true
        return true
    end

    for _, lang in ipairs(config.languages) do
        handle(lang)
    end

    if not opts.dry_run and #summary.failed > 0 then
        error('tree-sitter-manager parser maintenance failed:\n' .. table.concat(summary.failed, '\n'))
    end

    notify(
        string.format(
            'tree-sitter-manager parsers: %d installed, %d updated, %d adopted, %d skipped, %d failed',
            #summary.installed,
            #summary.updated,
            #summary.adopted,
            #summary.skipped,
            #summary.failed
        )
    )

    return {
        state_path = path,
        summary = summary,
    }
end

return M
