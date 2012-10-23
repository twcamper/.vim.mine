link_dir()
{
  local TARGET=$1
  local LINK_DIR=$2
  ln -sfvt $LINK_DIR $TARGET
}

install_to_my_home()
{
  make_swap_dirs $MAIN_USER_HOME

  if has_janus;then
    # ~/.gvimrc should be present but let's make sure!
    save_and_link $MAIN_USER_HOME/.vim/janus/vim/gvimrc $MAIN_USER_HOME/.gvimrc

    # ~/.janus
    save_and_link_dir $MAIN_USER_HOME/.vim.mine/.janus $MAIN_USER_HOME

    save_and_link $MAIN_USER_HOME/.vim.mine/linux/.vimrc $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/linux/.vimrc.after $MAIN_USER_HOME/.vimrc.after
    save_and_link $MAIN_USER_HOME/.vim.mine/linux/.gvimrc.after $MAIN_USER_HOME/.gvimrc.after
  else
    save_and_link $MAIN_USER_HOME/.vim.mine/common/settings.vim $MAIN_USER_HOME/.vimrc
    save_and_link $MAIN_USER_HOME/.vim.mine/linux/gvim.settings.vim $MAIN_USER_HOME/.gvimrc
  fi
}

install_for_all_users()
{
  make_swap_dirs_for_everybody
  if has_janus;then
    install_to_my_home
    make_links_to_main_user $ROOT_HOME

    everybody_else make_links_to_main_user
  else
    global_install
  fi
}

clean_all()
{
  clean $ROOT_HOME
  clean /etc/vim
  clean $MAIN_USER_HOME
  everybody_else clean

  # .vim dir
  restore_or_remove_dir $ROOT_HOME/.vim
  everybody_else restore_or_remove_dir /.vim
  # .vim.mine
  restore_or_remove_dir $ROOT_HOME/.vim.mine
  everybody_else restore_or_remove_dir /.vim.mine
}

global_install()
{
  save_and_link $MAIN_USER_HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
  save_and_link $MAIN_USER_HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
}

make_links_to_main_user()
{
  local USER_HOME=$1

  save_and_link     $MAIN_USER_HOME/.vimrc        $USER_HOME/.vimrc
  save_and_link     $MAIN_USER_HOME/.gvimrc       $USER_HOME/.gvimrc
  save_and_link     $MAIN_USER_HOME/.vimrc.after  $USER_HOME/.vimrc.after
  save_and_link     $MAIN_USER_HOME/.gvimrc.after $USER_HOME/.gvimrc.after
  save_and_link_dir $MAIN_USER_HOME/.vim          $USER_HOME
  save_and_link_dir $MAIN_USER_HOME/.vim.mine     $USER_HOME
  save_and_link_dir $MAIN_USER_HOME/.janus        $USER_HOME
}

make_swap_dirs()
{
  USER=`basename $1`
  mkdir -vp $1/.vim.local/{_swap,_backup}
  chown -cR $USER:$USER $1/.vim.local

}

everybody_else()
{
  local FUNCTION=$1
  local EXTRA_ARG=$2
  for user in `ls $USERS_HOME | grep -v $MAIN_USER`; do
    $FUNCTION $USERS_HOME/$user$EXTRA_ARG
  done
}
make_swap_dirs_for_everybody()
{
  make_swap_dirs $ROOT_HOME
  make_swap_dirs $MAIN_USER_HOME
  everybody_else make_swap_dirs
}
