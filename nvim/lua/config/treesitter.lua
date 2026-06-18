local function range_from_node(node)
    local start_row, start_col, end_row, end_col = node:range()
    return { start_row, start_col, end_row, end_col }
end

local function same_range(lhs, rhs)
    return lhs[1] == rhs[1] and lhs[2] == rhs[2] and lhs[3] == rhs[3] and lhs[4] == rhs[4]
end

local function current_selection_range()
    local pos1 = vim.fn.getpos('v')
    local pos2 = vim.fn.getpos('.')

    if pos1[2] > pos2[2] or (pos1[2] == pos2[2] and pos1[3] > pos2[3]) then
        pos1, pos2 = pos2, pos1
    end

    if pos2[3] == #vim.fn.getline(pos2[2]) + 1 then
        pos2[2] = pos2[2] + 1
        pos2[3] = 0
    else
        local region = vim.fn.getregionpos(pos2, pos2, { exclusive = false })
        pos2 = region[#region][2]
    end

    return { pos1[2] - 1, pos1[3] - 1, pos2[2] - 1, pos2[3] }
end

local function select_range(range)
    local start_row, start_col, end_row, end_col = unpack(range)

    if end_col == 0 then
        end_row = end_row - 1
        end_col = #vim.fn.getline(end_row + 1) + 1
    end

    vim.cmd.normal({ 'v\27', bang = true })
    vim.fn.setpos('\'<', { 0, start_row + 1, start_col + 1, 0 })
    vim.fn.setpos('\'>', { 0, end_row + 1, end_col, 0 })
    vim.cmd.normal({ 'gv', bang = true })
end

local function select_with_native_parent(target_range)
    local previous_range = current_selection_range()

    for _ = 1, 100 do
        vim.treesitter.select('parent', 1)

        local range = current_selection_range()
        if same_range(range, target_range) then
            return true
        end
        if same_range(range, previous_range) then
            break
        end

        previous_range = range
    end

    return false
end

local function node_matches_any(node, candidates)
    for _, candidate in ipairs(candidates) do
        if node:equal(candidate) then
            return true
        end
    end

    return false
end

local function scope_nodes(bufnr, lang, root)
    local ok, query = pcall(vim.treesitter.query.get, lang, 'locals')
    if not ok or not query then
        return {}
    end

    local scopes = {}
    local start_row, _, end_row, _ = root:range()

    for _, match in query:iter_matches(root, bufnr, start_row, end_row + 1) do
        for id, nodes in pairs(match) do
            if query.captures[id] == 'local.scope' then
                for _, node in ipairs(nodes) do
                    scopes[#scopes + 1] = node
                end
            end
        end
    end

    return scopes
end

local function native_select(target)
    return function()
        vim.treesitter.select(target, vim.v.count1)
    end
end

local function select_scope()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })

    if not parser then
        vim.treesitter.select('parent', vim.v.count1)
        return
    end

    parser:parse()

    local lang = parser:lang()
    local trees = parser:trees()
    local root = trees[1] and trees[1]:root()
    if not root then
        vim.treesitter.select('parent', vim.v.count1)
        return
    end

    local range = current_selection_range()
    local node = parser:named_node_for_range(range, { ignore_injections = false })
    local scopes = scope_nodes(bufnr, lang, root)

    while node do
        node = node:parent()

        if node and node_matches_any(node, scopes) then
            local node_range = range_from_node(node)
            if not same_range(range, node_range) then
                if not select_with_native_parent(node_range) then
                    select_range(node_range)
                end
                return
            end
        end
    end

    vim.treesitter.select('parent', vim.v.count1)
end

local function has_parser(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, nil, { error = false })
    return parser ~= nil
end

local function map(bufnr, mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
        buffer = bufnr,
        silent = true,
        desc = desc,
    })
end

local function attach_buffer(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    if vim.b[bufnr].config_treesitter_selection_maps then
        return
    end

    if not has_parser(bufnr) then
        return
    end

    map(bufnr, 'n', 'v.', native_select('parent'), '󰆧 Start Tree-sitter selection')
    map(bufnr, 'x', '.', native_select('parent'), '󰆧 Grow Tree-sitter selection')
    map(bufnr, 'x', ';', select_scope, '󰆧 Grow Tree-sitter selection to scope')
    map(bufnr, 'x', ',', native_select('child'), '󰆧 Shrink Tree-sitter selection')

    vim.b[bufnr].config_treesitter_selection_maps = true
end

local group = vim.api.nvim_create_augroup('config-treesitter', { clear = true })

vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
    group = group,
    callback = function(args)
        attach_buffer(args.buf)
    end,
})

if vim.bo.filetype ~= '' then
    attach_buffer(0)
end
