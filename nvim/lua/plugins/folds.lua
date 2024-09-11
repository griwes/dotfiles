return {
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = 'VeryLazy',
        opts = {
            open_fold_hl_timeout = 400,
            close_fold_kinds = {},
            enable_get_fold_virt_text = true,
            priority = 10,
            provider_selector = function()
                return { 'treesitter', 'indent' }
            end,
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
            local handler = function(virt_text, lnum, end_lnum, width, truncate, ctx)
                local total_lines = vim.api.nvim_buf_line_count(0)
                local folded_lines = end_lnum - lnum

                width = math.min(width, vim.bo[0].textwidth + 15)

                local extra_padding = (' '):rep(math.floor(vim.fn.log10(total_lines)) - math.floor(vim.fn.log10(folded_lines)))
                local suffix = ('%s%d lines, %2d%%'):format(extra_padding, folded_lines, folded_lines / total_lines * 100)
                local remaining_width = width - vim.fn.strdisplaywidth(suffix) - 2

                local ret = {}

                local append_virt_text = function(virt_text_, truncate_, special_hl)
                    if remaining_width == 0 then
                        return
                    end

                    special_hl = special_hl or 'Italic'

                    for _, chunk in ipairs(virt_text_) do
                        local chunk_text = chunk[1]
                        local chunk_hl = { chunk[2] or 'SpecialComment', special_hl }

                        local chunk_width = vim.fn.strdisplaywidth(chunk_text)
                        if chunk_width > remaining_width then
                            chunk_text = truncate_(chunk_text, remaining_width)
                            if chunk_text == nil then
                                return
                            end
                            remaining_width = 0
                        else
                            remaining_width = remaining_width - chunk_width
                        end

                        table.insert(ret, { chunk_text, chunk_hl })

                        if remaining_width == 0 then
                            break
                        end
                    end

                    return true
                end

                local trim_front = function(virt_text_)
                    for i = 1, #virt_text_ do
                        virt_text_[i][1] = virt_text_[i][1]:match('^%s*(.*)')
                        if (virt_text_[i][1] ~= '') then
                            break
                        end
                    end
                end

                local trim_back = function(virt_text_)
                    for i = #virt_text_, 1, -1 do
                        virt_text_[i][1] = virt_text_[i][1]:match('([^%s]*)%s*$')
                        if (virt_text_[i][1] ~= '') then
                            break
                        end
                    end
                end

                trim_back(virt_text)
                append_virt_text(virt_text, truncate)
                local added_separator = append_virt_text({{ '  󰇘  ', 'SpecialComment' }}, function()
                    return nil
                end, 'SpecialComment')

                if added_separator then
                    local end_virt_text = ctx.get_fold_virt_text(end_lnum)
                    trim_front(end_virt_text)
                    trim_back(end_virt_text)
                    append_virt_text(end_virt_text, truncate)
                end

                suffix = (' '):rep(remaining_width) .. suffix
                table.insert(ret, { suffix, 'SpecialComment' })

                return ret
            end
            opts['fold_virt_text_handler'] = handler
            require('ufo').setup(opts)
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
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
