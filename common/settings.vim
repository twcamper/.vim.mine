"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OPTION SETTINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"see /etc/vim/vimrc from Debian package version of vim
"
if has("syntax")
  syntax on
endif

"see /etc/vim/vimrc from Debian package version of vim
"
if has("autocmd")
  " have Vim jump to the last position when reopening a file
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

  " have Vim load indentation rules and plugins according to the detected filetype.
  filetype plugin indent on
endif

" for additional option ideas, see /etc/vim/vimrc from Debian package version of vim
"
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set nu          " line numbering on
set listchars+=eol:$
set autoindent
set autoread  " reload files edited by other processes
set smartindent

" guard for vim.tiny
if has("g:colors_name")
  color koehler
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" KEY MAPPINGS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 
" These should work on any version of vim, (including vim.tiny)
" on either OS X or Linux
"
" fast Escape
inoremap jj <Esc>
" command line
cnoremap jj <C-c> " quit command-line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>

"
" Save/Write file with ^s
"
" Normal, visual, and operator-pending mode
map <C-s> <Esc>:w<CR>
" insert mode, then return to insert mode
imap <C-s> <Esc>:w<CR>a
" 
" insert a blank line below, staying in command mode
map <C-i> o<Esc>

