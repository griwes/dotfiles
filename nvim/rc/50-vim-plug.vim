" automatically install vim-plug
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin(stdpath('data') . '/plugged')

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" themes
Plug 'dikiaap/minimalist'
Plug 'haishanh/night-owl.vim'

" language support
Plug 'neovim/nvim-lspconfig'
Plug 'p00f/clangd_extensions.nvim'
Plug 'SmiteshP/nvim-navic'
Plug 'RRethy/vim-illuminate'
Plug 'smjonas/inc-rename.nvim'
Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'theHamsta/nvim-semantic-tokens'
Plug 'simrat39/rust-tools.nvim'

Plug 'kosayoda/nvim-lightbulb'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'nvim-lua/plenary.nvim'

" debugger
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'theHamsta/nvim-dap-virtual-text'

Plug 'craigemery/vim-autotag'

" autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'wellle/tmux-complete.vim'

Plug 'ray-x/lsp_signature.nvim'

" notifications & ui
Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'
Plug 'folke/noice.nvim'

" general utility plugins
Plug 'junegunn/fzf'
Plug 'ibhagwan/fzf-lua'
Plug 'weilbith/nvim-code-action-menu'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi'
Plug 'gcmt/wildfire.vim'
Plug 'phaazon/hop.nvim'

Plug 'luochen1990/rainbow'
Plug 'mbbill/undotree'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'machakann/vim-highlightedyank'
Plug 'markonm/traces.vim'

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

Plug 'sindrets/diffview.nvim'

call plug#end()

lua <<EOF
require("notify").setup {
    background_colour = '#000000'
}
vim.notify = require("notify")

require('noice').setup {
    cmdline = {
        view = "cmdline"
    },
    messages = {
        view_history = "popup"
    },
    popupmenu = {
        backend = "cmp"
    },
    lsp_progress = {
        enabled = true
    },

    views = {
        popup = {
            border = {
                style = "rounded"
            }
        }
    }
}

require'hop'.setup()
EOF

map  <Leader>f :HopChar1<CR>
nmap <Leader>f :HopChar1MW<CR>
map  <Leader>s :HopChar2<CR>
nmap <Leader>s :HopChar2MW<CR>
map  <Leader>w :HopWord<CR>
nmap <Leader>w :HopWordMW<CR>
map  <Leader>L :HopLine<CR>
nmap <Leader>L :HopLineMW<CR>

map  <Leader>/ :HopPattern<CR>
nmap <Leader>/ :HopPattern<CR>

map  <Leader>; :HopWordCurrentLineAC<CR>
map  <Leader>l :HopVerticalBC<CR>
map  <Leader>k :HopVerticalAC<CR>
map  <Leader>j :HopWordCurrentLineBC<CR>
