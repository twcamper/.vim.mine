" is janus installed?  ( If so, we will source ~/.vimrc.after )
"
" are we running a version of vim larger than vim.tiny?
if filereadable(expand("~/.vim/janus/vim/vimrc")) && has("cindent")
  "" skip Janus config for vim.tiny,
  "" by testing for a feature only found in 'normal'
  source ~/.vim/janus/vim/vimrc
else

  " No janus, so we get our settings without any ~/.vimrc.after or
  " /etc/vim/vimrc.local
  source ~/.vim.mine/common/settings.vim
endif
