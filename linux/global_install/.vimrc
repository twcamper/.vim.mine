" is janus installed?
if filereadable(expand("~/.vim/janus/vim/vimrc"))
  "" skip Janus config for vim.tiny,
  "" by testing for a feature only found in 'normal'
  if has("cindent")
    source ~/.vim/janus/vim/vimrc
  endif
endif
"
" If janus is NOT installed, see ~/.vim.mine/common/settings.vim
" That file is linked to /etc/vim/vimrc.local in a global install
