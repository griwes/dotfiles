-- bootstrap lazy
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- colorscheme
    { 'EdenEast/nightfox.nvim', lazy = false, priority = 1000 }, -- TODO: configure better, move config

    -- icons
    { 'nvim-tree/nvim-web-devicons' },

    -- status line
    { 'nvim-lualine/lualine.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim'
        }
    },
    { 'SmiteshP/nvim-navic' },

    -- ui
    { 'rcarriga/nvim-notify' },
    { 'folke/noice.nvim' },
    { 'MunifTanjim/nui.nvim' },
    { 'weilbith/nvim-code-action-menu' }, -- TODO: configure keybinds
    { 'stevearc/dressing.nvim' }, -- TODO: configure keybinds?
    { 'levouh/tint.nvim' },
    -- { 'nyngwang/NeoZoom.lua' }, -- TODO: cool, but breaks with folke/trouble, reinvestigate in the future
    { 'mrjones2014/smart-splits.nvim' }, -- TODO: configure keybinds
    { 'kwkarlwang/bufresize.nvim' },
    { 'folke/which-key.nvim' }, -- TODO: configure
    { 'folke/trouble.nvim' },
    { 'j-hui/fidget.nvim' },
    { 'stevearc/aerial.nvim' }, -- TODO: configure keybind
    { 'tiagovla/scope.nvim' },

    -- fuzzy finders
    { 'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim', -- TODO: configure keybinds
        }
    }, -- TODO: configure keybinds
    { 'molecule-man/telescope-menufacture' }, -- TODO: configure keybinds
    { 'nvim-telescope/telescope-dap.nvim' }, -- TODO: configure keybinds

    -- movement
    { 'ggandor/leap.nvim' }, -- TODO: configure keybinds
    { 'ethanholz/nvim-lastplace' },

    -- visibility
    { 'lukas-reineke/indent-blankline.nvim' },
    { 'machakann/vim-highlightedyank' },

    -- git
    { 'lewis6991/gitsigns.nvim' }, -- TODO: configure keybinds
    { 'sindrets/diffview.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        }
    }, -- TODO: configure
    { 'akinsho/git-conflict.nvim' },

    -- treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
    { 'haringsrob/nvim_context_vt' },
    { 'mrjones2014/nvim-ts-rainbow' },

    -- lsp
    { 'neovim/nvim-lspconfig' },
    { 'SmiteshP/nvim-navic' },
    { 'RRethy/vim-illuminate' },
    { 'smjonas/inc-rename.nvim' }, -- TODO: configure keybinds
    { 'https://git.sr.ht/~whynothugo/lsp_lines.nvim' },
    { 'joechrisellis/lsp-format-modifications.nvim' },
    { 'kosayoda/nvim-lightbulb' },

    { 'p00f/clangd_extensions.nvim' },
    { 'simrat39/rust-tools.nvim' },

    -- dap
    { 'mfussenegger/nvim-dap' }, -- TODO: configure keybinds
    { 'rcarriga/nvim-dap-ui' },
    { 'theHamsta/nvim-dap-virtual-text' },

    -- autocomplete
    { 'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'rcarriga/cmp-dap', -- TODO: configure
        }
    },

    -- other utilities
    { 'krady21/compiler-explorer.nvim' },
    { 'AckslD/nvim-FeMaco.lua' }, -- TODO: configure keybinds
    { 'riddlew/swap-split.nvim' }, -- TODO: configure keybinds
    { 'stevearc/oil.nvim' }, -- TODO: configure
    { 'EtiamNullam/deferred-clipboard.nvim' },
    { 'nacro90/numb.nvim' },
    { 'tiagovla/buffercd.nvim' }
})


-- TODO: move this elsewhere
require('nightfox').setup({
    options = {
        transparent = true
    }
})
vim.cmd [[ colorscheme nightfox ]]

require('plugins/status')
require('plugins/ui')
require('plugins/movement')
require('plugins/visibility')
require('plugins/git')
require('plugins/treesitter')
require('plugins/lsp')
require('plugins/dap')
require('plugins/autocomplete')
require('plugins/utilities')

require('plugins/telescope') -- near the end?

-- the very last thing, since it iterates through all HL groups
require('tint').setup({
    tint = -60,
    highlight_ignore_patterns = { "WinSeparator", "Status.*", "VertSplit" },
    window_ignore_function = function(winid)
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buftype = vim.api.nvim_buf_get_option(bufid, 'buftype')
        local filetype = vim.api.nvim_buf_get_option(bufid, 'filetype')
        local floating = vim.api.nvim_win_get_config(winid).relative ~= ''

        -- Do not tint `terminal` or floating windows or dap UI, tint everything else
        return buftype == 'terminal' or
            floating or
            filetype:find('dap', 1, true) == 1 or
            filetype == 'Trouble'
    end
})

