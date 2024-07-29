set termguicolors
set tabstop=2 
set softtabstop=4
set shiftwidth=2
set expandtab
set smartindent
set number
set numberwidth=5
set relativenumber
set signcolumn=yes
set noswapfile
set nobackup
set undodir="$HOME/.config/nvim/undodir"
set undofile
set incsearch
set nohlsearch
set ignorecase
set smartcase
set nowrap
set splitbelow
set splitright
set hidden
set scrolloff=999
set noshowmode
set updatetime=250 
set encoding=UTF-8
set mouse=a
"set spell

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run Plug Install if there are missing plugins
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
      \| endif
" call plugins
call plug#begin('$HOME/.config/nvim/plugged')

Plug 'tpope/vim-surround' " Surrounding ()
Plug 'ap/vim-css-color' " CSS Color Preview
Plug 'rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'ryanoasis/vim-devicons' " Developer Icons
Plug 'tc50cal/vim-terminal' " Vim Terminal
Plug 'vim-airline/vim-airline' " Status bar
Plug 'neovim/nvim-lspconfig' "neovim lsp
Plug 'mbbill/undotree' " undotree
Plug 'nvim-lua/plenary.nvim' 
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'folke/tokyonight.nvim', { 'branch': 'main' } " Color scheme
Plug 'preservim/nerdtree' "Nerd Tree
Plug 'ctrlpvim/ctrlp.vim' "CtrlP
Plug 'preservim/nerdcommenter' "commenter
Plug 'neoclide/coc.nvim', {'branch': 'release'} "coc nvim
Plug 'mattn/emmet-vim' 
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'pearofducks/ansible-vim', { 'do': './UltiSnips/generate.sh' } 
Plug 'rebelot/kanagawa.nvim'
Plug 'jiangmiao/auto-pairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'
Plug 'junegunn/fzf.vim'


call plug#end()

lua require('lua_files')

" inoremap <c-b> <Esc>:Lex<cr>:vertical resize 40<cr>
" nnoremap <c-b> <Esc>:Lex<cr>:vertical resize 40<cr>

"custom keybinds
nmap <C-z> :UndotreeToggle<CR>
nmap <C-b> :NERDTreeToggle<CR>
nmap <C-p> :CtrlP<CR>

vmap // <plug>NERDCommenterToggle
nmap // <plug>NERDCommenterToggle
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" lazygit
nmap <C-g> :LazyGit<CR>

"telescope

nmap <C-f> :Telescope find_files <CR>
nmap <C-d> :Telescope live_grep <CR>

"inoremap <c-/> ++<cr>
"nnoremap <c-/> ++<cr>

" background and colorscheme

set background=dark
colorscheme kanagawa

let g:airline_theme='onehalfdark'

" let g:airline#extensions#tabline#enabled = 1






