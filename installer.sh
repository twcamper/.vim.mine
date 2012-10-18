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
  return 12
  save $HOME
  if is_linux;then
    if has_janus;then
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc $HOME/.vimrc
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc.after $HOME/.vimrc.after
      ln -s $HOME/.vim.mine/linux/.gvimrc.after $HOME/.gvimrc.after
    else
      ln -s $HOME/.vim.mine/common/settings.vim $HOME/.vimrc
      ln -s $HOME/.vim.mine/linux/gvim.settings.vim $HOME/.gvimrc
    fi
  fi
  if is_mac;then
    if has_janus;then
      ln -s $HOME/.vim.mine/linux/local_install/.vimrc.after
    else
      echo foo foo
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
      mv $path $path.old
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
      #echo $path.old
      if [ -e "$path.old" ];then
        mv $path.old $path
      else
        rm $path
      fi
    fi
  done
}

clean_global()
{
  echo clean global
}

INSTALL_SCOPE=$1

case $INSTALL_SCOPE in
  self ) install_under_my_home
    ;;
  all[-_]users ) install_for_all_users
    ;;
  * ) echo "Usage:  ./installer.sh all_users|self"
    exit 1
    ;;
esac
