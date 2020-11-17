set nocompatible              " Vundle setup
filetype off                  " Vundle setup

" Vim-plug for package management
" :PlugInstall

" Dependencies:
" brew install fzf, for fuzzy file search
" brew install bat, a cat alternative with syntax highlighting
" brew install the_silver_searcher, a faster searcher

call plug#begin('~/.vim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'
Plug 'lilydjwg/colorizer'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-surround'
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'thoughtbot/vim-rspec'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'

" Git and Github integrations. Rhubarb is needed for :GBrowse
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Interact with tmux from vim
Plug 'benmills/vimux'

" Vim-turbux builds on vimux and allows TDD for Rails with single key map
Plug 'jgdavey/vim-turbux'

" Set dark material theme
" https://github.com/material-theme/vsc-material-theme#official-portings
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

" Initialize plugin system
call plug#end()

set encoding=utf8
set nobackup
set nowritebackup
set noswapfile
set visualbell
set ruler                  " Show cursor position at all times
set showcmd                " Display incomplete commands
set laststatus=2           " Always display the status line
set autowrite              " Automatically write before running commands
set clipboard=unnamed      " Share the clipboard with OS
set autoindent             " Copy indent from current line
set wildmenu               " Enhanced completion in command-line
set wildmode=list:longest  " When more than one match, list all matches and complete till longest common string
set backspace=2            " Backspace deletes like most programs in insert mode
set nojoinspaces           " Use one space, not two, after punctuation.
set showmatch              " When a bracket is inserted, briefly jump to matching one
set textwidth=80           " Break long strings into multiple lines
set so=15                  " Don't hide buffer after pasting content
let g:netrw_liststyle=3    " Set default style of file explorer
let g:netrw_dirhistmax = 0 " Don't save history of network writes

" Softtabs tabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Color scheme settings.
syntax on
colorscheme material

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Tame searching / moving
set ignorecase
set smartcase
set incsearch
set hlsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Turbux config
if filereadable("dev.yml")
  let g:turbux_command_prefix = ''
  let g:turbux_command_test_unit = 'dev test'
elseif filereadable('Gemfile')
  let g:turbux_command_prefix = 'bundle exec'
endif

" hack to fix broken 'run focused test' since https://github.com/jgdavey/vim-turbux/pull/36
let g:turbux_test_type = ''

" Airline config
let g:airline_theme='material'
let g:airline_powerline_fonts = 1

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    exec ':bd ' . old_name
    redraw!
  endif
endfunction

map <leader>, :call RenameFile()<cr>

" Run file if we know how
function! RunFile(filename)
  :w
  :silent !clear
  if match(a:filename, '\.rb$') != -1
    exec ":!ruby " . a:filename
  elseif match(a:filename, '\.py$') != -1
    exec ":!python " . a:filename
  elseif match(a:filename, '\.go$') != -1
    exec ":!go run " . a:filename
  elseif match(a:filename, '\.sh$') != -1
    exec ":!bash " . a:filename
  elseif match(a:filename, '\.tex$') != -1
    exec ":!make "
  elseif match(a:filename, 'makefile$') != -1
    exec ":!make "
  else
    exec ":!echo \"Don't know how to execute: \"" . a:filename
  end
endfunction

map <leader>e :call RunFile(expand("%"))<cr>

" Nerdtree: Automatically open nerd tree if vim opened without any file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NerdTree Toggle mode
noremap <leader>n :NERDTreeToggle<CR>

" Faster search
" https://robots.thoughtbot.com/faster-grepping-in-vim
" https://github.com/ggreer/the_silver_searcher

if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " bind Leader g to grep word under cursor
  nnoremap <leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

  if !exists(":Ag")
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap <leader>G :Ag<SPACE>
  endif
else
  echo "Silver searcher not found, please run: brew install the_silver_searcher"
endif

" Toggle - comment, uses Vim-commentary
nmap <C-\> gcc<ESC>
vmap <C-\> gcc<ESC>

" Replace t with tabnew in console
ca t tabnew

" %% gives you the current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" Browse open buffers
nmap <leader>b :Buffers<CR>
nmap <Leader>f :Files<CR>

"Have leader D just delete the line
nmap <leader>d "_d

" Make Y behave like other capitals
map Y y$

" Remove the vertical border since we have the number column
set fillchars+=vert:\│
hi VertSplit ctermfg=Black ctermbg=None
set number
