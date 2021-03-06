""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gvim settings which could be linked as a standalone ~/.gvimrc
" or sourced into ~/.gvimrc.after if we have janus installed
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand("~/.vim.mine/common/gvim.settings.vim"))
  source ~/.vim.mine/common/gvim.settings.vim
endif

" work around linux gui F11 problem by making it a nice safe refresh
"
" https://bugs.launchpad.net/ubuntu/+source/vim/+bug/702314?comments=all
"
if has("gui_gtk2") || has("gui_gtk") || has("gui_gnome")
  map <F10> <c-L>
endif
