link_dir()
{
  local TARGET=$1
  local LINK_DIR=$2
  ln -sfv $TARGET $LINK_DIR
}

install_to_my_home()
{
  make_swap_dirs $MAIN_USER_HOME
  if has_janus;then
    # ~/.gvimrc should be present but let's make sure!
    save_and_link $MAIN_USER_HOME/.vim/janus/vim/gvimrc $MAIN_USER_HOME/.gvimrc

    # ~/.janus
    save_and_link_dir $MAIN_USER_HOME/.vim.mine/.janus $MAIN_USER_HOME

    # ~/.vimrc should be present but let's make sure!
    save_and_link $MAIN_USER_HOME/.vim/janus/vim/vimrc $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.vimrc.after $MAIN_USER_HOME/.vimrc.after
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.gvimrc.after $MAIN_USER_HOME/.gvimrc.after
  else
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.vimrc $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.gvimrc.after $MAIN_USER_HOME/.gvimrc
  fi
}

install_for_all_users()
{
  echo "run '$ $THIS_SCRIPT_FILE self' on the mac"
  exit 1
  install_to_my_home
}

clean_all()
{
  echo "run '$ $THIS_SCRIPT_FILE clean self' on the mac"
  exit 1
  clean $MAIN_USER_HOME
}

make_swap_dirs()
{
  mkdir -vp $1/.vim.local/{_swap,_backup}
}
