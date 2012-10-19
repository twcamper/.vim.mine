#! /usr/bin/env bash

LOCAL_TARGETS=".vimrc .vimrc.before .vimrc.after .gvimrc .gvimrc.before .gvimrc.after"

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

  if [[ -e $LINK_NAME ]]; then
    mv -v $LINK_NAME $LINK_NAME.old
  fi
  ln -sv $TARGET $LINK_NAME
}

install_to_my_home()
{
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
    else
      save_and_link $HOME/.vim.mine/mac/.vimrc $HOME/.vimrc
    fi
  fi
}

global_install()
{
  if is_linux;then
    sudo save_and_link $HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
    sudo save_and_link $HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
  fi
  if is_mac;then
    sudo save_and_link $HOME/.vim.mine/common/settings.vim /usr/share/vim/vimrc.local
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

clean()
{
  local HOME=$1
  for t in $LOCAL_TARGETS
  do
    path=$HOME/$t
    if [ -e $path ];then
      if [ -e "$path.old" ];then
        mv -v $path.old $path
      else
        rm -v $path
      fi
    fi
  done
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
  * )
    echo Usage:
    echo "       $ ./installer.sh [clean] all_users|self"
    exit 1
esac
