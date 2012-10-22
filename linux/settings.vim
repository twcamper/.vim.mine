if filereadable(expand("~/.vim.mine/common/settings.vim"))
  source ~/.vim.mine/common/settings.vim
endif

"any linux specific options or mappings go here
set directory=~/.vim.local/_swap
set backupdir=~/.vim.local/_backup
