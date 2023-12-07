return {
    {
        'nvim-telescope/telescope.nvim',
        -- dir = '/home/griwes/projects/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'molecule-man/telescope-menufacture',
            'olimorris/persisted.nvim',
            'nvim-telescope/telescope-dap.nvim',      -- TODO: configure keybinds
            'aaronhallaert/advanced-git-search.nvim', -- TODO: configure keybinds
            'rcarriga/nvim-notify',
            'mfussenegger/nvim-dap',
            'tiagovla/scope.nvim',
            'AckslD/nvim-neoclip.lua',
        },
        init = function()
            local utils = require('utils.lsp')

            utils.add_callback(function(_, _, bufnr)
                local wk = require('which-key')

                wk.register({
                    g = {
                        r = { '<cmd>Telescope lsp_references<cr>', 'LSP references' },
                        d = { '<cmd>Telescope lsp_definitions<cr>', 'LSP definitions' },
                        t = { '<cmd>Telescope lsp_type_definitions<cr>', 'LSP type definitions' },
                    },
                }, { buffer = bufnr });

                wk.register({
                    l = {
                        name = 'LSP',
                        a = { '<cmd>Telescope diagnostics<cr>', 'LSP diagnostics' },
                        b = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'LSP diagnostics (buf)' },
                    },
                }, { prefix = '<leader>', buffer = bufnr })
            end)
        end,
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            telescope.setup({
                defaults = {
                    layout_strategy = 'horizontal',
                    layout_config = {
                        horizontal = {
                            preview_width = 0.6,
                        },
                        vertical = {
                            prompt_position = 'bottom',
                            mirror = true,
                        },
                    },
                    preview = {
                        treesitter = true,
                    },
                    dynamic_preview_title = true,
                },
                pickers = {
                    buffers = {
                        mappings = {
                            i = {
                                ['<CR>'] = actions.select_drop,
                                ['<C-x>'] = actions.delete_buffer,
                            },
                            n = {
                                ['<CR>'] = actions.select_drop,
                                ['x'] = actions.delete_buffer,
                                ['<C-x>'] = actions.delete_buffer,
                            },
                        },
                    },
                    find_files = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                    git_files = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                    diagnostics = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                    lsp_references = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                    lsp_definitions = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                    lsp_type_definitions = {
                        mappings = {
                            i = { ['<CR>'] = actions.select_drop },
                            n = { ['<CR>'] = actions.select_drop },
                        }
                    },
                },
                extensions = {
                    menufacture = {
                        mappings = {
                            main_menu = { [{ 'i', 'n' }] = '<C-t>' },
                        },
                    },
                    advanced_git_search = {
                        diff_plugin = 'diffview',
                    }
                }
            })

            vim.cmd [[ highlight TelescopeBorder guifg=#7ad5d6 ]]
            vim.cmd 'autocmd User TelescopePreviewerLoaded setlocal number'

            -- https://github.com/nvim-telescope/telescope.nvim/issues/2027
            vim.api.nvim_create_autocmd('WinLeave', {
                callback = function()
                    if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'i' then
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'i', false)
                    end
                end,
            })

            telescope.load_extension('menufacture')
            telescope.load_extension('dap')
            telescope.load_extension('persisted')
            telescope.load_extension('advanced_git_search')
            telescope.load_extension('notify')
            telescope.load_extension('scope')
            telescope.load_extension('neoclip')
            telescope.load_extension('macroscope')
        end,
        cmd = {
            'Telescope'
        },
        keys = {
            { '<C-t>', '<cmd>Telescope<cr>' },
            { '<C-p>', function() require('telescope').extensions.menufacture.find_files() end },
            { '<C-n>', function() require('telescope').extensions.menufacture.grep_string() end },
            { '<C-m>', function() require('telescope').extensions.menufacture.live_grep() end },
            { '<C-g>', function() require('telescope').extensions.menufacture.git_files() end },
            { '<C-b>', '<cmd>Telescope buffers<cr>' },
            { '<C-j>', '<cmd>Telescope jumplist<cr>' },

            { '<leader>gc', '<cmd>Telescope git_commits<cr>' },
            { '<leader>gb', '<cmd>Telescope git_branches<cr>' },
            { '<leader>ghb', '<cmd>Telescope git_bcommits<cr>' },
            { '<leader>ghr', '<cmd>Telescope git_bcommits_range<cr>' },
            { '<leader>gss', '<cmd>Telescope git_stash<cr>' },

            { '<leader>dc', '<cmd>Telescope dap configurations<cr>' },
            { '<leader>db', '<cmd>Telescope dap list_breakpoints<cr>' },
            { '<leader>dv', '<cmd>Telescope dap variables<cr>' },
            { '<leader>df', '<cmd>Telescope dap frames<cr>' },
            { '<leader>hy',  '<cmd>Telescope neoclip<cr>' },
            { '<leader>hm',  '<cmd>Telescope macroscope<cr>' },
        },
    }
}
