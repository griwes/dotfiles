local M = {}

function M.pad_lines(lines, opts)
    opts = opts or {}
    local left = string.rep(' ', opts.left or 1)
    local right = string.rep(' ', opts.right or 1)

    return vim.iter(lines)
        :map(function(line)
            return left .. line .. right
        end)
        :totable()
end

return M
