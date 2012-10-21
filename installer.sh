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

save_and_link_dir()
{
  local TARGET=$1
  local LINK_DIR=$2
  local LINK_NAME=$LINK_DIR/`basename $TARGET`
  if [[ -d $LINK_NAME ]]; then
    cp -rv $LINK_NAME $LINK_NAME.old
    rm -rvf $LINK_NAME
  fi
  ln -sfvt $LINK_DIR $TARGET
}

make_swap_dirs()
{
  USER=`basename $1`
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

  if has_janus;then
    # The janus install makes these 2 links.
    # As is a development and testing convenience, start off by making sure they are intact.$
    # It's useless but doesn't hurt anything during normal installation runs.$
    ln -sfv $HOME/.vim/janus/vim/vimrc $HOME/.vimrc
    ln -sfv $HOME/.vim/janus/vim/gvimrc $HOME/.gvimrc

    # ~/.janus
    save_and_link_dir $HOME/.vim.mine/.janus $HOME

    if is_linux;then
      save_and_link $HOME/.vim.mine/linux/.vimrc $HOME/.vimrc
      save_and_link $HOME/.vim.mine/linux/.vimrc.after $HOME/.vimrc.after
      save_and_link $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
    fi
    if is_mac;then
      save_and_link $HOME/.vim.mine/mac/.vimrc.after $HOME/.vimrc.after
      save_and_link $HOME/.vim.mine/mac/.gvimrc.after $HOME/.gvimrc.after
    fi
  else
    if is_linux;then
      save_and_link $HOME/.vim.mine/common/settings.vim $HOME/.vimrc
      save_and_link $HOME/.vim.mine/linux/gvim.settings.vim $HOME/.gvimrc
    fi
    if is_mac;then
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
  local MAIN_USER_HOME=$1
  if has_janus;then
    echo 'We have Janus!'
    install_to_my_home $MAIN_USER_HOME
    # 2 - make symlinks for root
    # 3 - make symlinks and chown them for /home/everbody-else
  else
    global_install $MAIN_USER_HOME
  fi
  make_swap_dirs_for_everybody
}

restore_or_remove()
{
  if [ -e "$1.old" ];then
    mv -fv $1.old $1
  else
    if [[ -h $1 ]]; then
      rm -fv $1
    else
      echo Not removing "$1" because it is not a symlink
    fi
  fi
}

restore_or_remove_dir()
{
  local DIR=$1
  if [[ -d $DIR ]]; then
    if [[ -h $DIR ]]; then
      rm -rfv $DIR
      if [[ -d "$DIR.old" ]]; then
        mv -fv $DIR.old $DIR
      fi
    else
      echo Not removing "$DIR" because it is not a symlink
    fi
  else
    if [[ -e $DIR ]]; then
      echo $DIR is not a dir
    fi
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

  # ~/.janus
  restore_or_remove_dir $DIR/.janus
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
    * )
      echo Usage:
      echo "       $ $THIS_SCRIPT_FILE [clean] all_users|self"
      exit 1
  esac
fi


#Tasks

#1 - link all users to main user
#2 - global for mac
#3 - revert/clean global for mac
#4 - add -h .vim.mine to clean_special_cases
#5 - deal with ~/.vim for root and everbody else (cleanup, setting to .old)
