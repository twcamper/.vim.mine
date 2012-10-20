#! /usr/bin/env bash


has_janus()
{
  [[ -e $HOME/.vim/janus/vim/vimrc ]]
}

is_linux()
{
  [[ `uname -s` = 'Linux' ]]
}

is_mac()
{
  [[ `uname -s` = 'Darwin' ]]
}

save_and_link()
{
  local TARGET=$1
  local LINK_NAME=$2

  # save off if it exists as a symlink or a regular file.
  # the symlink might be broken or not.
  if [[ -h $LINK_NAME || -e $LINK_NAME ]]; then
    mv -fv $LINK_NAME $LINK_NAME.old
  fi
  ln -sfv $TARGET $LINK_NAME
}

make_swap_dirs()
{
  if [[ ! -d $1/.vim.local/_swap ]]; then
    mkdir -vp $1/.vim.local/_swap
  fi
  if [[ ! -d $1/.vim.local/_backup ]]; then
    mkdir -vp $1/.vim.local/_backup
  fi
}

install_to_my_home()
{
  make_swap_dirs $HOME
  if is_linux;then
    if has_janus;then
      save_and_link $HOME/.vim.mine/linux/.vimrc $HOME/.vimrc
      save_and_link $HOME/.vim.mine/linux/.vimrc.after $HOME/.vimrc.after
      save_and_link $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
      # link $HOME/.vim.mine/.janus as DIR
    else
      save_and_link $HOME/.vim.mine/common/settings.vim $HOME/.vimrc
      save_and_link $HOME/.vim.mine/linux/gvim.settings.vim $HOME/.gvimrc
    fi
  fi
  if is_mac;then
    if has_janus;then
      save_and_link $HOME/.vim.mine/mac/.vimrc.after $HOME/.vimrc.after
      save_and_link $HOME/.vim.mine/mac/.gvimrc.after $HOME/.gvimrc.after
    else
      save_and_link $HOME/.vim.mine/mac/.vimrc $HOME/.vimrc
      save_and_link $HOME/.vim.mine/mac/.gvimrc.after $HOME/.gvimrc
    fi
  fi
}

global_install()
{
  if is_linux;then
    save_and_link $HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
    save_and_link $HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
  fi
  if is_mac;then
    save_and_link $HOME/.vim.mine/common/settings.vim /usr/share/vim/vimrc.local
  fi
}

install_for_all_users()
{
  return 13
  if has_janus;then
    echo 'We have Janus!'
    # 1 - install_to_my_home
    # 2 - make symlinks for root
    # 3 - make symlinks and chown them for /home/everbody-else
  else
    global_install
  fi
}
restore_janus()
{
  if has_janus;then
    ln -sfv $HOME/.vim/janus/vim/vimrc $HOME/.vimrc
    ln -sfv $HOME/.vim/janus/vim/gvimrc $HOME/.gvimrc
  fi
}

restore_or_remove()
{
  if [ -e "$1.old" ];then
    mv -fv $1.old $1
  else
    rm -fv $1
  fi
}

clean_special_cases()
{
  local DIR=$1

  # ~/.gvimrc when there is no janus
  if ! has_janus ; then
    local GVIMRC=$DIR/.gvimrc
    if [[ -h $GVIMRC ]]; then
      restore_or_remove $GVIMRC
    fi
    local OLD=$GVIMRC.old
    if [[ -h $OLD ]]; then
      if ls -l $OLD | grep -e '.vim/janus/vim/gvimrc$'; then
        rm -fv $OLD
      fi
    fi
  fi

  # swap dirs
  rm -rvf $DIR/.vim.local
}

clean()
{
  local DIR=$1
  for t in .vimrc .vimrc.before .vimrc.after .gvimrc.before .gvimrc.after vimrc gvimrc vimrc.local gvimrc.local
  do
    path=$DIR/$t
    if [[ -h "$path" ]];then
      restore_or_remove $path
    fi
  done

  clean_special_cases $DIR
}

clean_all()
{
  echo clean global
}

###########################
#
# EXECUTE AN ACTION
#
###########################
ALL_ARGS_AS_A_STRING=$*

case $ALL_ARGS_AS_A_STRING in
  clean\ self )
    clean $HOME
    ;;
  clean\ all[-_]users )
    clean_all
    ;;
  self )
    install_to_my_home
    ;;
  all[-_]users )
    install_for_all_users
    ;;
  restore[-_]janus )
    restore_janus
    ;;
  * )
    echo Usage:
    echo "       $ ./installer.sh [clean] all_users|self|restore_janus"
    exit 1
esac
