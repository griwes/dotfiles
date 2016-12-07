filetype off
call vundle#begin($LOCAL_BUNDLE_PATH)

" vundle itself
Plugin 'gmarik/vundle'

" vim themes
Plugin 'nanotech/jellybeans.vim'

" git support
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" language support
Plugin 'Valloric/YouCompleteMe'
Plugin 'jeaye/color_coded'
Plugin 'hallison/vim-markdown'
Plugin 'indenthtml.vim'
Plugin 'rhysd/vim-clang-format'

" files and movement
Plugin 'tpope/vim-unimpaired'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'ivalkeen/vim-ctrlp-tjump'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'craigemery/vim-autotag'
Plugin 'camelcasemotion'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'a.vim'
Plugin 'gcmt/wildfire.vim'
Plugin 'easymotion/vim-easymotion'

" additional tools
Plugin 'bling/vim-airline'
Plugin 'junegunn/rainbow_parentheses.vim'
Plugin 'SirVer/ultisnips'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'godlygeek/tabular'
Plugin 'mhinz/vim-startify'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'mbbill/undotree'
Plugin 'Yggdroot/indentLine'

Plugin 'mattn/gist-vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-characterize'
Plugin 'tpope/vim-abolish'

" shell and tmux
Plugin 'edkolev/promptline.vim'
Plugin 'edkolev/tmuxline.vim'

call vundle#end()
filetype plugin indent on

