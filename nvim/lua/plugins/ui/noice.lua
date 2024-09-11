return {
    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            'rcarriga/nvim-notify',
        },
        lazy = false,
        init = function()
            local Input = require("nui.input")
            local event = require("nui.utils.autocmd").event

            local function get_prompt_text(prompt, default_prompt)
                local prompt_text = prompt or default_prompt
                if prompt_text:sub(-1) == ":" then
                    prompt_text = "[" .. prompt_text:sub(1, -2) .. "]"
                end
                return prompt_text
            end

            local UIInput = Input:extend("UIInput")

            function UIInput:init(opts, on_done)
                local border_top_text = get_prompt_text(opts.prompt, "[Input]")
                local default_value = tostring(opts.default or "")

                UIInput.super.init(self, {
                    relative = "cursor",
                    position = {
                        row = 1,
                        col = 0,
                    },
                    size = {
                        -- minimum width 20
                        width = math.max(20, vim.api.nvim_strwidth(default_value),
                            vim.api.nvim_strwidth(border_top_text) + 4),
                    },
                    border = {
                        style = "rounded",
                        text = {
                            top = border_top_text,
                            top_align = "center",
                        },
                    },
                    style = 'minimal',
                    win_options = {
                        winhighlight = "NormalFloat:DiagnosticSignInfo,FloatBorder:DiagnosticSignInfo",
                    },
                }, {
                    default_value = default_value,
                    on_close = function()
                        on_done(nil)
                    end,
                    on_submit = function(value)
                        on_done(value)
                    end,
                })

                -- cancel operation if cursor leaves input
                self:on(event.BufLeave, function()
                    on_done(nil)
                end, { once = true })

                -- cancel operation if <Esc> is pressed
                self:map("n", "<Esc>", function()
                    on_done(nil)
                end, { noremap = true, nowait = true })
                self:map("i", "<Esc>", function()
                    on_done(nil)
                end, { noremap = true, nowait = true })
            end

            local input_ui

            vim.ui.input_nui = function(opts, on_confirm)
                assert(type(on_confirm) == "function", "missing on_confirm function")

                if input_ui then
                    -- ensure single ui.input operation
                    vim.api.nvim_err_writeln("busy: another input is pending!")
                    return
                end

                input_ui = UIInput(opts, function(value)
                    if input_ui then
                        -- if it's still mounted, unmount it
                        input_ui:unmount()
                    end
                    -- pass the input value
                    on_confirm(value)
                    -- indicate the operation is done
                    input_ui = nil
                end)

                input_ui:mount()
            end
        end,
        opts = {
            messages = {
                view_history = 'popup'
            },
            popupmenu = {
                backend = 'cmp'
            },
            lsp = {
                progress = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                    trigger = false,
                },
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },

            presets = {
                long_message_to_split = true,
                lsp_doc_border = true,

                inc_rename = true,
            },

            views = {
                popup = {
                    border = {
                        style = 'rounded',
                    },
                },
                hover = {
                    border = {
                        padding = { 0, 0 },
                    },
                },
            },
        },
        keys = {
            { '<C-esc>', '<cmd>Noice dismiss<cr>', },
        },
    },
    --[[ {
        dir = '~/projects/signatory.nvim',
        opts = {
        },
    } ]]
}
