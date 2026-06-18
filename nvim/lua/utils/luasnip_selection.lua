local M = {}

local function selected_text(snip)
    local selected = snip.env and snip.env.LS_SELECT_RAW
    if not selected or #selected == 0 then
        return nil
    end

    selected = vim.deepcopy(selected)
    selected[1] = selected[1]:match('^%s*(.-)%s*$')

    return selected
end

function M.jump_into_with_selection(snip)
    local selected = selected_text(snip)
    local exit_node = snip.insert_nodes and snip.insert_nodes[0]

    if selected and exit_node then
        exit_node:set_text(selected)
    end

    return snip:jump_into(1)
end

function M.expand_opts(opts)
    opts = vim.tbl_deep_extend('force', {}, opts or {})
    opts.jump_into_func = opts.jump_into_func or M.jump_into_with_selection

    return opts
end

function M.lsp_expand(body, opts)
    require('luasnip').lsp_expand(body, M.expand_opts(opts))
end

function M.snip_expand(snip, opts)
    require('luasnip').snip_expand(snip, M.expand_opts(opts))
end

return M
