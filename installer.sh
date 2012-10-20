#! /usr/bin/env bash

USER_NAME_PATTERN="[^\/]+$"

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
  USER=`echo $1 | grep -oE $USER_NAME_PATTERN`
  SWAP=$1/.vim.local/_swap
  BACKUP=$1/.vim.local/_backup
  if [[ ! -d $SWAP ]]; then
    mkdir -vp $SWAP
    chown -c $USER:$USER $SWAP
  fi
  if [[ ! -d  $BACKUP ]]; then
    mkdir -vp $BACKUP
    chown -c $USER:$USER $BACKUP
  fi
}

make_swap_dirs_for_everybody()
{
  make_swap_dirs $HOME  # root
  for user in `ls /home`; do
    make_swap_dirs /home/$user
  done
}

install_to_my_home()
{
  local HOME=$1
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
  local HOME=$1
  if is_linux;then
    save_and_link $HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
    save_and_link $HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
  fi
  if is_mac;then
    save_and_link $HOME/.vim.mine/common/settings.vim /usr/share/vim/vimrc.local
    save_and_link $HOME/.vim.mine/mac/.gvimrc.after $HOME/gvimrc.local
  fi
}

install_for_all_users()
{
  if has_janus;then
    echo 'We have Janus!'
    # 1 - install_to_my_home $1
    # 2 - make symlinks for root
    # 3 - make symlinks and chown them for /home/everbody-else
  else
    global_install $1
  fi
  make_swap_dirs_for_everybody
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
  clean $HOME  # root
  clean /etc/vim  # and for the mac???
  for user in `ls /home`; do
    clean /home/$user
  done
}

ALL_ARGS_AS_A_STRING=$*
THIS_SCRIPT_FILE=$0

if [[ `id -u` == 0 ]]; then
  #######################################################
  #
  # RUN FUNCTION (SUB-ROUTINE) AS ROOT
  #
  # '$@' is all arguments, i.e., the function name ($1)
  #       and any subsequent args ($2, etc)
  #
  # This is called from a 'sudo' call below.
  #######################################################
  $@
else
  ###########################
  #
  # VALIDATE AND RUN USER CLI COMMAND
  #
  ###########################
  case $ALL_ARGS_AS_A_STRING in
    clean\ self )
      clean $HOME
      ;;
    clean\ all[-_]users )
      sudo $THIS_SCRIPT_FILE clean_all
      ;;
    self )
      install_to_my_home $HOME
      ;;
    all[-_]users )
      sudo $THIS_SCRIPT_FILE install_for_all_users $HOME
      ;;
    restore[-_]janus )
      restore_janus
      ;;
    * )
      echo Usage:
      echo "       $ $THIS_SCRIPT_FILE [clean] all_users|self|restore_janus"
      exit 1
  esac
fi
