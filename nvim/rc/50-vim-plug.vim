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
Plug 'prabirshrestha/vim-lsp'
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'

Plug 'craigemery/vim-autotag'

" autocomplete
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'yami-beta/asyncomplete-omni.vim'

Plug 'wellle/tmux-complete.vim'

" general utility plugins
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

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

call plug#end()

let g:rainbow_active = 1

lua require'hop'.setup {}

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
