return {
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        opts = {
            open_fold_hl_timeout = 400,
            close_fold_kinds = {},
            preview = {
                mappings = {
                    scrollU = '<C-s>',
                    scrollD = '<C-d>',
                    jumpTop = '[',
                    jumpBot = ']',
                },
            },
        },
        init = function()
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        config = function(_, opts)
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local totalLines = vim.api.nvim_buf_line_count(0)
                local foldedLines = endLnum - lnum
                local prefix = ('──  ──┤ ')
                local extraPadding = (' '):rep(math.floor(vim.fn.log10(totalLines)) - math.floor(vim.fn.log10(foldedLines)))
                local suffix = ('┤ %s%d lines, %2d%% ├──'):format(extraPadding, foldedLines, foldedLines / totalLines * 100)
                local newVirtText = { { prefix, 'SpecialComment' } }
                local prefWidth = vim.fn.strdisplaywidth(prefix) + 1
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - prefWidth - sufWidth
                local curWidth = 0
                for i, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    if i == 1 then
                        chunkText = vim.fn.trim(chunkText, ' \t', 1) or chunkText
                    end
                    local hlGroup = { chunk[2] or 'SpecialComment' }
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, { chunkText, hlGroup })
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. ('─'):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                local rAlignAppndx = math.max(width - 1 - curWidth - prefWidth - sufWidth, 0)
                suffix = ' ├' .. ('─'):rep(rAlignAppndx - 2) .. suffix
                table.insert(newVirtText, { suffix, 'SpecialComment' })
                return newVirtText
            end
            opts['fold_virt_text_handler'] = handler
            require('ufo').setup(opts)
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
            vim.keymap.set('n', 'K', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)
            vim.keymap.set('n', 'zp', require('ufo').peekFoldedLinesUnderCursor)

            vim.api.nvim_create_augroup('FoldLevelSet', { clear = true })
            vim.api.nvim_create_autocmd('BufCreate', {
                group = 'FoldLevelSet',
                callback = function()
                    vim.opt_local.foldlevel = 99
                end
            })
        end,
    },
    {
        'chrisgrieser/nvim-origami',
        event = 'BufReadPost',
        opts = {
            setupFoldKeymaps = false,
        },
        keys = {
            { 'j', function() require('origami').h() end },
            { ';', function() require('origami').l() end }
        }
    }
}
