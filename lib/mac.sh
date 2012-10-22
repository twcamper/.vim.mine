link_dir()
{
  local TARGET=$1
  local LINK_DIR=$2
  ln -sfv $TARGET $LINK_DIR
}

install_to_my_home()
{
  if has_janus;then
    # ~/.gvimrc should be present but let's make sure!
    save_and_link $MAIN_USER_HOME/.vim/janus/vim/gvimrc $MAIN_USER_HOME/.gvimrc

    # ~/.janus
    save_and_link_dir $MAIN_USER_HOME/.vim.mine/.janus $MAIN_USER_HOME

    # ~/.vimrc should be present but let's make sure!
    save_and_link $MAIN_USER_HOME/.vim/janus/vim/vimrc $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.vimrc.after $MAIN_USER_HOME/.vimrc.after
  else
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.vimrc $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.gvimrc.after $MAIN_USER_HOME/.gvimrc
  fi
}

install_for_all_users()
{
  if has_janus; then
    install_to_my_home
  fi
  global_install
}

clean_all()
{
  clean /etc/vim
  clean /usr/share/vim
  clean $MAIN_USER_HOME
}

global_install()
{
  # make global config files that source {g,}vimrc.local
  mkdir -p /etc/vim
  cp /usr/share/vim/vimrc /etc/vim/
  cp /usr/share/vim/gvimrc /etc/vim/

  tee -a /etc/vim/vimrc <<-EOF
" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
EOF

    tee -a /etc/vim/gvimrc <<-EOF
" Source a global configuration file if available
if filereadable("/etc/vim/gvimrc.local")
  source /etc/vim/gvimrc.local
endif
EOF

  # link {g,}vimrc at default location to our new ones
  save_and_link /etc/vim/vimrc /usr/share/vim/vimrc
  save_and_link /etc/vim/gvimrc /usr/share/vim/gvimrc

  # link {g,}vimrc.local to our settings
  save_and_link $MAIN_USER_HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
  save_and_link $MAIN_USER_HOME/.vim.mine/mac/.gvimrc.after /etc/vim/
}
