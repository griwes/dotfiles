-- Adapted from saghen/blink.cmp's LuaSnip snippets source:
-- lua/blink/cmp/sources/snippets/luasnip.lua at commit 78336bc.
-- Upstream license: MIT, Copyright (c) 2024 Liam Dyer.
-- Local change: preserve Blink's execute flow while passing LuaSnip a
-- jump_into_func for selected-text insertion.
local function add_luasnip_callback(snip, event, callback)
    local events = require('luasnip.util.events')
    if snip.callbacks == nil then
        return
    end

    snip.callbacks[-1] = snip.callbacks[-1] or {}
    snip.callbacks[-1][events[event]] = callback
end

local function expand_luasnip_source(source, ctx, item, callback)
    local luasnip = require('luasnip')
    local snip = luasnip.get_id_snippet(item.data.snip_id)

    if not snip then
        if callback then
            callback()
        end
        return
    end

    if snip.regTrig then
        local doc_trig = source.config.prefer_doc_trig and snip.docTrig
        snip = snip:get_pattern_expand_helper()

        if doc_trig then
            add_luasnip_callback(snip, 'pre_expand', function(expanded_snip, _)
                if #expanded_snip.insert_nodes == 0 then
                    expanded_snip.insert_nodes[0].static_text = { doc_trig }
                else
                    local matches = { string.match(doc_trig, expanded_snip.trigger) }
                    for i, match in ipairs(matches) do
                        local idx = i ~= #matches and i or 0
                        expanded_snip.insert_nodes[idx].static_text = { match }
                    end
                end
            end)
        end
    end

    local cursor = ctx.get_cursor()
    cursor[1] = cursor[1] - 1

    local range = require('blink.cmp.lib.text_edits').get_from_item(item).range
    local clear_region = {
        from = { range.start.line, range.start.character },
        to = cursor,
    }

    local line = ctx.get_line()
    local line_to_cursor = line:sub(1, cursor[2])
    local range_text = line:sub(range.start.character + 1, cursor[2])

    local expand_params = snip:matches(line_to_cursor, {
        fallback_match = range_text ~= line_to_cursor and range_text,
    })

    if expand_params ~= nil then
        if expand_params.clear_region ~= nil then
            clear_region = expand_params.clear_region
        elseif expand_params.trigger ~= nil then
            clear_region = {
                from = { cursor[1], cursor[2] - #expand_params.trigger },
                to = cursor,
            }
        end
    end

    require('utils.luasnip_selection').snip_expand(snip, {
        expand_params = expand_params,
        clear_region = clear_region,
    })

    if callback then
        callback()
    end
end

local function in_select_mode()
    local mode = vim.api.nvim_get_mode().mode
    return mode == 's' or mode == 'S' or mode == '\19'
end

local function tabout_forward()
    if in_select_mode() then
        return false
    end

    local ok, tabout = pcall(require, 'tabout')
    if not ok then
        return false
    end

    tabout.tabout()
    return true
end

local function tabout_backward()
    if in_select_mode() then
        return false
    end

    local ok, tabout = pcall(require, 'tabout')
    if not ok then
        return false
    end

    local before = vim.api.nvim_win_get_cursor(0)
    tabout.taboutBack()
    local after = vim.api.nvim_win_get_cursor(0)

    local config_ok, config = pcall(require, 'tabout.config')
    return before[1] ~= after[1] or before[2] ~= after[2] or (config_ok and config.options.act_as_shift_tab)
end

local function copilot_nes()
    return require('utils.copilot_nes').jump_or_apply()
end

local function markdown_table_cell(next)
    if vim.bo.filetype ~= 'markdown' or in_select_mode() then
        return false
    end

    local node_ok, node = pcall(vim.treesitter.get_node)
    if not node_ok or not node then
        return false
    end

    local utils_ok, table_utils = pcall(require, 'table-nvim.utils')
    if not utils_ok or not table_utils.is_tbl_node(node) then
        return false
    end

    local nav_ok, nav = pcall(require, 'table-nvim.nav')
    if not nav_ok then
        return false
    end

    nav.move(next)
    return true
end

local function markdown_table_next_cell()
    return markdown_table_cell(true)
end

local function markdown_table_previous_cell()
    return markdown_table_cell(false)
end

local function signature_offset_after_padding(label, offset)
    local _, newline_count = label:sub(1, offset):gsub('\n', '')
    return offset + 1 + newline_count * 2
end

local function pad_signature_label(label)
    local lines = vim.split(label, '\n', { plain = true })
    return table.concat(require('utils.float').pad_lines(lines), '\n')
end

local function pad_signature_help(signature_help)
    if type(signature_help) ~= 'table' or type(signature_help.signatures) ~= 'table' then
        return signature_help
    end

    local padded = vim.deepcopy(signature_help)

    for _, signature in ipairs(padded.signatures) do
        if type(signature.label) == 'string' then
            local label = signature.label
            signature.label = pad_signature_label(label)

            for _, parameter in ipairs(signature.parameters or {}) do
                if type(parameter.label) == 'table' then
                    local start_offset = parameter.label[1]
                    local end_offset = parameter.label[2]

                    if type(start_offset) == 'number' and type(end_offset) == 'number' then
                        parameter.label = {
                            signature_offset_after_padding(label, start_offset),
                            signature_offset_after_padding(label, end_offset),
                        }
                    end
                end
            end
        end
    end

    return padded
end

local function pad_blink_signature_help()
    local signature_window = require('blink.cmp.signature.window')

    if signature_window._dotfiles_pads_signature_help then
        return
    end

    local open_with_signature_help = signature_window.open_with_signature_help
    signature_window.open_with_signature_help = function(context, signature_help)
        return open_with_signature_help(context, pad_signature_help(signature_help))
    end
    signature_window._dotfiles_pads_signature_help = true
end

return {
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function(_, opts)
            local npairs = require('nvim-autopairs')
            local Rule = require('nvim-autopairs.rule')
            local cond = require('nvim-autopairs.conds')

            npairs.setup(opts)

            local function rule2(a1, ins, a2, lang)
                npairs.add_rule(Rule(ins, ins, lang)
                    :with_pair(function(opts)
                        return a1 .. a2 == opts.line:sub(opts.col - #a1, opts.col + #a2 - 1)
                    end)
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    :with_del(function(opts)
                        local col = vim.api.nvim_win_get_cursor(0)[2]
                        return a1 .. ins .. ins .. a2 == opts.line:sub(col - #a1 - #ins + 1, col + #ins + #a2)
                    end))
            end
            rule2('(', ' ', ')')
            rule2('{', ' ', '}')

            for _, punct in pairs({ ',', ';' }) do
                npairs.add_rule(Rule('', punct)
                    :with_move(function(opts)
                        return opts.char == punct
                    end)
                    :with_pair(function()
                        return false
                    end)
                    :with_del(function()
                        return false
                    end)
                    :with_cr(function()
                        return false
                    end)
                    :use_key(punct))
            end
        end,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        dependencies = {
            'rafamadriz/friendly-snippets',
            'xzbdmw/colorful-menu.nvim',
            'L3MON4D3/LuaSnip',
            'fang2hou/blink-copilot',
            'Fildo7525/pretty_hover',
            'Kaiser-Yang/blink-cmp-git',
        },
        -- branch = 'main',
        -- build = 'cargo build --release',
        version = '1.*',

        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            snippets = {
                preset = 'luasnip',
                expand = function(body)
                    require('utils.luasnip_selection').lsp_expand(body)
                end,
            },

            fuzzy = {
                implementation = 'prefer_rust_with_warning',
            },

            keymap = {
                preset = 'none',
                ['<C-Space>'] = { 'show' },
                ['<Tab>'] = {
                    'select_next',
                    'snippet_forward',
                    copilot_nes,
                    tabout_forward,
                    markdown_table_next_cell,
                    'fallback',
                },
                ['<S-Tab>'] = {
                    'select_prev',
                    'snippet_backward',
                    tabout_backward,
                    markdown_table_previous_cell,
                    'fallback',
                },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Esc>'] = { 'hide_signature', 'cancel', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-s>'] = { 'scroll_documentation_up', 'fallback' },
                ['<Enter>'] = { 'accept', 'fallback' },
                ['<C-Enter>'] = { 'select_and_accept' },
            },

            cmdline = {
                enabled = true,

                keymap = {
                    ['<Enter>'] = { 'fallback' },
                    ['<Down>'] = { 'fallback' },
                    ['<Up>'] = { 'fallback' },
                },

                completion = {
                    ghost_text = {
                        enabled = false,
                    },

                    menu = {
                        auto_show = true,
                    },
                },
            },

            completion = {
                keyword = {
                    range = 'full',
                },

                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },

                menu = {
                    border = 'rounded',
                    max_height = 15,

                    draw = {
                        treesitter = { 'lsp' },

                        columns = { { 'source_name' }, { 'kind_icon' }, { 'label' } },

                        components = {
                            label = {
                                text = function(ctx)
                                    return require('colorful-menu').blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require('colorful-menu').blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },

                documentation = {
                    auto_show = true,
                    window = {
                        border = 'rounded',
                    },
                    draw = function(opts)
                        if opts.item and opts.item.documentation then
                            local out = require('pretty_hover.parser').parse(
                                opts.item.documentation.value or opts.item.documentation
                            )
                            if not opts.item.documentation.value then
                                opts.item.documentation = {
                                    kind = 'markdown',
                                }
                            end
                            opts.item.documentation.value = out:string()
                        end

                        opts.default_implementation(opts)
                    end,
                },

                ghost_text = {
                    enabled = false,
                    show_without_selection = false,
                },
            },

            signature = {
                enabled = true,

                trigger = {
                    show_on_keyword = true,
                    show_on_insert = true,
                },

                window = {
                    border = 'rounded',
                },
            },

            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },

            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'copilot', 'git' },

                providers = {
                    snippets = {
                        module = 'blink.cmp.sources.snippets',
                        score_offset = -1,
                        override = {
                            execute = expand_luasnip_source,
                        },
                    },
                    copilot = {
                        name = 'Copilot',
                        module = 'blink-copilot',
                        async = true,
                    },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        -- Completion UI for Lazydev; LuaLS workspace policy stays in lazydev.nvim opts.
                        score_offset = 100,
                        async = true,
                    },
                    git = {
                        module = 'blink-cmp-git',
                        name = 'Git',
                        enabled = function()
                            return vim.tbl_contains({ 'gitcommit', 'markdown' }, vim.bo.filetype)
                        end,
                        --- @module 'blink-cmp-git'
                        --- @type blink-cmp-git.Options
                        opts = {},
                        score_offset = -3,
                        async = true,
                    },
                },
            },
        },
        config = function(_, opts)
            require('blink.cmp').setup(opts)
            pad_blink_signature_help()
        end,
        opts_extend = { 'sources.default' },
    },
}
