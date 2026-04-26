" =============================================================================
" Vim IDE Configuration
" =============================================================================
" gay

" --- Basic Settings ---
set number              " line numbers
set relativenumber      " relative line numbers
set showcmd             " show partial commands
set showmode            " show current mode
set ruler               " show cursor position
set wildmenu            " enhanced command completion
set wildmode=longest,list,full
set hidden              " allow switching buffers without saving
set updatetime=300      " faster git gutter updates
set shortmess+=c        " no ins-completion messages

" --- Tabs & Indentation ---
set tabstop=4           " visible tab width
set shiftwidth=4        " auto-indent width
set softtabstop=4       " backspace deletes 4 spaces
set expandtab           " tabs -> spaces
set autoindent          " copy indent from current line
set smartindent         " smart auto-indent

" --- Search ---
set nohlsearch          " no highlight search results
set incsearch           " incremental search
set ignorecase          " case-insensitive search
set smartcase           " case-sensitive if uppercase used

" --- Appearance ---
syntax on               " syntax highlighting
set termguicolors       " true colors
set splitright          " vertical split to the right
set splitbelow          " horizontal split below

" Dark color scheme
colorscheme darkblue
hi Normal guibg=#1a1a2e
hi NonText guifg=#333355
hi LineNr guifg=#444466 guibg=#1a1a2e
hi CursorLineNr guifg=#8888aa guibg=NONE
hi Pmenu guibg=#2a2a3e guifg=#cccccc
hi PmenuSel guibg=#444466 guifg=#ffffff
hi PmenuSbar guibg=#2a2a3e
hi PmenuThumb guibg=#444466

" No bright highlights
hi Search guibg=#333344 guifg=NONE
hi IncSearch guibg=#333344 guifg=NONE
hi Visual guibg=#333355 guifg=NONE
hi MatchParen guibg=NONE guifg=NONE gui=NONE
hi LspReferenceText guibg=#2a2a3e guifg=NONE gui=NONE
hi LspReferenceRead guibg=#2a2a3e guifg=NONE gui=NONE
hi LspReferenceWrite guibg=#2a2a3e guifg=NONE gui=NONE
hi CocHighlightText guibg=NONE guifg=NONE gui=NONE
hi CocCodeLens guifg=#444466 gui=NONE
hi CocFadeOut guifg=#333355 gui=NONE
hi CocMenuSel guibg=#444466
hi DiagnosticVirtualText guifg=#555577 gui=NONE

" Disable floating window borders and shadows
hi CocFloating guibg=#2a2a3e guifg=#cccccc
hi CocPumSearch guibg=#2a2a3e guifg=#cccccc

" No bright info windows from LSP
hi NormalFloat guibg=#1e1e2e guifg=#cccccc
hi FloatBorder guifg=#333344 guibg=#1e1e2e

" --- Backups & Swap ---
set noswapfile
set nobackup
set nowritebackup
set undofile            " persistent undo
set undodir=~/.vim/undo

" --- Mouse ---
set mouse=a             " enable mouse support

" --- Clipboard ---
set clipboard=unnamedplus  " use system clipboard

" --- Encoding ---
set encoding=utf-8
set fileencoding=utf-8

" --- Key Mappings ---
let mapleader = " "     " space as leader key

" Save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Close buffer
nnoremap <leader>q :bdelete<CR>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Resize splits
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Better tab behavior
nnoremap <leader>e :NvimTreeToggle<CR>

" --- Autocmds ---
" Create undo directory if it doesn't exist
if !isdirectory($HOME . '/.vim/undo')
    call mkdir($HOME . '/.vim/undo', 'p')
endif

" =============================================================================
" Plugins
" =============================================================================
call plug#begin('~/.vim/plugged')

" File explorer
Plug 'nvim-tree/nvim-web-devicons'  " icons
Plug 'nvim-tree/nvim-tree.lua'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Syntax / Language
Plug 'tpope/vim-commentary'      " gc to comment
Plug 'tpope/vim-surround'        " change surrounding chars
Plug 'tpope/vim-repeat'          " repeat plugin actions
Plug 'tpope/vim-fugitive'        " git integration
Plug 'tpope/vim-unimpaired'      " extra bracket mappings

" Auto-completion (CoC)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" =============================================================================
" Plugin Configurations
" =============================================================================

" --- NvimTree (File Explorer) ---
let g:nvim_tree_disable_default_provider = 1
let g:nvim_tree_hijack_netrw = 1
let g:nvim_tree_git_hl = 1
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_add_trailing = 1
let g:nvim_tree_auto_close = 0

" --- CoC (Completion) ---
" Limit snippet suggestions to 3
let g:coc_snippet_next = 0

" Suppress rust-analyzer and other LSP noise
let g:coc_enable_filetype_method = 0

" Snippet max items
let g:coc_max_completion_items = 3

" Use <Tab> and <S-Tab> to navigate completion list
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <cr> to confirm completion
if has('patch8.0')
  inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
else
  inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
endif

" Go to definition
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Code actions
nnoremap <silent> <leader>ca <Plug>(coc-codeaction-cursor)
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>f <Plug>(coc-format-selected)

" Diagnostics navigation
nnoremap <silent> <leader>dj <Plug>(coc-diagnostic-next)
nnoremap <silent> <leader>dk <Plug>(coc-diagnostic-prev)

" Coc config file
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-pyright',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-highlight',
      \ ]

" --- FZF ---
let g:fzf_layout = { 'down': '~30%' }
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>

" --- Airline ---
let g:airline_powerline_fonts = 0
let g:airline_theme = 'dark_minimal'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

" =============================================================================
" End of Configuration
" =============================================================================
