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

install_under_my_home()
{
  save $HOME
  if is_linux;then
    if has_janus;then
      ln -s $HOME/.vim.mine/linux/.vimrc $HOME/.vimrc
      ln -s $HOME/.vim.mine/linux/.vimrc.after $HOME/.vimrc.after
      ln -s $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
    else
      ln -s $HOME/.vim.mine/common/settings.vim $HOME/.vimrc
      ln -s $HOME/.vim.mine/linux/gvim.settings.vim $HOME/.gvimrc
    fi
  fi
  if is_mac;then
    if has_janus;then
      ln -s $HOME/.vim.mine/mac/.vimrc.after $HOME/.vimrc.after
    else
      ln -s $HOME/.vim.mine/mac/.vimrc $HOME/.vimrc
    fi
  fi
}

global_install()
{
  if is_linux;then
    # save ???
    sudo ln -s $HOME/.vim.mine/common/settings.vim /etc/vim/vimrc.local
    sudo ln -s $HOME/.vim.mine/linux/gvim.settings.vim /etc/vim/gvimrc.local
  fi
  if is_mac;then
    # save ???
    sudo ln -s $HOME/.vim.mine/common/settings.vim /usr/share/vim/vimrc.local
  fi
}

install_for_all_users()
{
  return 13
  # global_save  # ???
  if has_janus;then
    echo 'We have Janus!'
    # 1 - install_under_my_home
    # 2 - make symlinks for root  -- do we save here?
    # 3 - make symlinks and chown them for /home/everbody-else  -- do we save here?
  else
    global_install
  fi
}

save()
{
  local HOME=$1
  for t in $LOCAL_TARGETS
  do
    path=$HOME/$t
    if [ -e "$path" ];then
      mv -v $path $path.old
    fi
  done
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
    install_under_my_home
    ;;
  all[-_]users )
    install_for_all_users
    ;;
  * )
    echo "Usage:  ./installer.sh [clean] all_users|self"
    exit 1
esac
