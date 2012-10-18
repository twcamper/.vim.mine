" this file is used if janus is installed
" if janus is NOT installed, we link ~/.vimrc to " ~/.vim.mine/common/settings.vim directly
" 
"
" 'has("cindent") -- Determines if we are running a version of vim larger than vim.tiny,
"                       because it is a feature only found in 'normal'.
"                       Without this guard, vim.tiny throws errors when janus
"                       tries to load itself using 'let' statements which are
"                       not supported below the 'normal' feature set.  'let'
"                       is not a feature we can test for with has(), however, so we use
"                       'cindent' as an expedient.
if filereadable(expand("~/.vim/janus/vim/vimrc")) && has("cindent")
    " the janus vimrc sources in ~/.vimrc.after,
    " which in turn sources in ~/.vim.mine/common/settings.vim
    source ~/.vim/janus/vim/vimrc
  endif
else
  " No janus, so we must get our settings without any
  " ~/.vimrc.after or /etc/vim/vimrc.local
  source ~/.vim.mine/common/settings.vim
endif
