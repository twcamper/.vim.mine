" this file is used when no janus is installed
if filereadable(expand("~/.vim.mine/common/settings.vim"))
  source ~/.vim.mine/common/settings.vim
endif

if filereadable(expand("~/.vim.mine/mac/settings.vim"))
  source ~/.vim.mine/mac/settings.vim
endif
