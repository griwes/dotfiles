" automatically install vim-plug
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

call plug#begin(stdpath('data') . '/plugged')

" plugin requirements
Plug 'roxma/nvim-yarp' " ncm2

" status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" themes
Plug 'dikiaap/minimalist'
Plug 'haishanh/night-owl.vim'

" language support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'arakashic/chromatica.nvim'
Plug 'craigemery/vim-autotag'

" autocomplete
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'ncm2/ncm2-github'

Plug 'ncm2/ncm2-neoinclude' | Plug 'Shougo/neoinclude.vim'

Plug 'wellle/tmux-complete.vim'

Plug 'fgrsnau/ncm2-otherbuf'

" general utility plugins
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-multiple-cursors'
Plug 'gcmt/wildfire.vim'
Plug 'easymotion/vim-easymotion'

Plug 'junegunn/rainbow_parentheses.vim'
Plug 'mbbill/undotree'
Plug 'Yggdroot/indentLine'

Plug 'machakann/vim-highlightedyank'
Plug 'markonm/traces.vim'

Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'roxma/vim-tmux-clipboard'

" debugging
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

call plug#end()
