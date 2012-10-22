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
  install_to_my_home
}

clean_all()
{
  clean $MAIN_USER_HOME
}
