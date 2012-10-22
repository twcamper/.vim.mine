#! /usr/bin/env bash

has_janus()
{
  [[ -e $MAIN_USER_HOME/.vim/janus/vim/vimrc ]]
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
    #cp -rv  $LINK_NAME $LINK_NAME.old
    #rm -rvf $LINK_NAME
    mv -fv $LINK_NAME $LINK_NAME.old
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
  make_swap_dirs /root
  everybody_else make_swap_dirs
}

install_to_my_home()
{
  local HOME=$MAIN_USER_HOME
  make_swap_dirs $HOME

  if has_janus;then
    # ~/.gvimrc should be present but let's make sure!
    save_and_link $HOME/.vim/janus/vim/gvimrc $HOME/.gvimrc

    # ~/.janus
    save_and_link_dir $HOME/.vim.mine/.janus $HOME

    if is_linux;then
      save_and_link $HOME/.vim.mine/linux/.vimrc $HOME/.vimrc
      save_and_link $HOME/.vim.mine/linux/.vimrc.after $HOME/.vimrc.after
      save_and_link $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
    fi
    if is_mac;then
      # ~/.vimrc should be present but let's make sure!
      save_and_link $HOME/.vim/janus/vim/vimrc $HOME/.vimrc
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

global_install()
{
  if is_linux;then
    save_and_link $MAIN_USER_HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
    save_and_link $MAIN_USER_HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
  fi
  if is_mac;then
    save_and_link $MAIN_USER_HOME/.vim.mine/common/settings.vim /usr/share/vim/vimrc.local
    save_and_link $MAIN_USER_HOME/.vim.mine/mac/.gvimrc.after /usr/share/gvimrc.local
  fi
}

everybody_else()
{
  local FUNCTION=$1
  local EXTRA_ARG=$2
  if is_linux; then local USER_HOME=/home; fi
  if is_mac; then local USER_HOME=/Users; fi
  for user in `ls $USER_HOME | grep -v $MAIN_USER`; do
    $FUNCTION $USER_HOME/$user$EXTRA_ARG
  done
}

install_for_all_users()
{
  if has_janus;then
    install_to_my_home
    make_links_to_main_user /root

    everybody_else make_links_to_main_user
  else
    global_install
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

  if ! has_janus ; then
    # ~/.gvimrc when there is no janus
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
  for t in .vimrc .gvimrc .vimrc.before .vimrc.after .gvimrc.before .gvimrc.after vimrc gvimrc vimrc.local gvimrc.local
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
  clean $MAIN_USER_HOME
  everybody_else clean

  # .vim dir
  restore_or_remove_dir /root/.vim
  everybody_else restore_or_remove_dir /.vim
  # .vim.mine
  restore_or_remove_dir /root/.vim.mine
  everybody_else restore_or_remove_dir /.vim.mine
}

restore_janus_links()
{
  ln -sfv $HOME/.vim/janus/vim/vimrc $HOME/.vimrc
  ln -sfv $HOME/.vim/janus/vim/gvimrc $HOME/.gvimrc
}

ALL_ARGS_AS_A_STRING=$*
THIS_SCRIPT_FILE=$0
SCRIPT_DIR="$( cd  "$( dirname $THIS_SCRIPT_FILE )" && pwd )"

# the NON-ROOT home dir of the installing user, i.e., the runner of this script
MAIN_USER_HOME=`echo $SCRIPT_DIR | grep -oE "^/(home|Users)/[^\/]+"`   # DO NOT RUN AS ROOT! pattern is for "/{home,Users}/username"
MAIN_USER=`basename $MAIN_USER_HOME`

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
      sudo $THIS_SCRIPT_FILE clean_all $HOME
      ;;
    self )
      install_to_my_home
      ;;
    all[-_]users )
      sudo $THIS_SCRIPT_FILE install_for_all_users $HOME
      ;;
    restore[-_]janus )
      restore_janus_links
      ;;
    * )
      echo Usage:
      echo "       $ $THIS_SCRIPT_FILE [clean] all_users|self|restore_janus"
      exit 1
  esac
fi


#Tasks

#2 - global for mac
#3 - revert/clean global for mac
